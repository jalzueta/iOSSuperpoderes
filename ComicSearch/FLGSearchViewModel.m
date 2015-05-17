//
//  FLGSearchViewModel.m
//  ComicSearch
//
//  Created by Javi Alzueta on 17/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSearchViewModel.h"
#import "FLGSearchResultViewModel.h"
#import "FLGComicVineClient.h"
#import "ManagedVolume.h"
#import "FLGResponse.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Groot/Groot.h>

@interface FLGSearchViewModel ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) FLGComicVineClient *client;
@property (nonatomic) NSUInteger currentPage; // Muchos servicos web inician su paginacion a "1"

// Stack de Core Data - Groot
@property (strong, nonatomic) GRTManagedStore *store;

// Contextos privado (escritura/borrado) y principal (lectura)
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

@property (strong, nonatomic) NSFetchedResultsController *frc;

@property (strong, nonatomic) RACSubject *didUpdateResultsSubject; //  es hija de RACSignal

@end

@implementation FLGSearchViewModel

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [FLGComicVineClient new];
        _currentPage = 1;
        
        _store = [GRTManagedStore temporaryManagedStore];
        
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.persistentStoreCoordinator = _store.persistentStoreCoordinator;
        
        _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateContext.persistentStoreCoordinator = _store.persistentStoreCoordinator;
        
        // Cuando se escriben datos en Core Data, el contexto en el que se escribe envía una notificacion a través de NSNotificationCenter. Nos surcribimos a esta notificacion
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(privateContextDidSave:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:self.privateContext]; // Solo nos interesan las notificaciones del contexto privado, que es el que va a escribir datos en base de datos
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:[ManagedVolume fetchRequestForAllVolumes]
                                                   managedObjectContext:_mainContext
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil];
        // Nos ponemos como delegados de frc para que nos lleguen los eventos, concretamente "controllerDidChangeContent"
        _frc.delegate = self;
        [_frc performFetch:NULL];
        
        // Enviamos una señal cada vez que se llame al método "controllerDidChangeContent", del delegado de NSFetchResultsController
        // Como hay un suscriptor (FLGSearchViewController) de esta señal "didUpdateResults", el recibirá la señal y lanzará el proceso correspondiente, en este caso "[self.tableView reloadData]"
//        _didUpdateResults = [self rac_signalForSelector:@selector(controllerDidChangeContent:)];
        
        _didUpdateResultsSubject = [RACSubject subject];
    }
    return self;
}

// Sobreescribimos la señal didUpdateResults, que es a la que esta suscrita el FLGSearchViewController para refrescar la tabla, y devolvemos una señal que estamos lanzando de forma manual mediante el evento de delegado de actualizacion de resultados del NSFetchedResultsController


- (RACSignal *)didUpdateResults{
    return self.didUpdateResultsSubject;
}

- (void)setQuery:(NSString *)query{
    if (![_query isEqualToString:query]) {
        _query = [query copy];
        [self beginNewSearch];
    }
}

- (NSUInteger)numberOfResults{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[0];
    return [sectionInfo numberOfObjects];
}

- (FLGSearchResultViewModel *) resultAtIndex:(NSUInteger)index{
    // FIXME: temporary
//    NSURL *testURL = [NSURL URLWithString:@"http://static.comicvine.com/uploads/scale_avatar/6/67663/2046031-01.jpg"];
//    return [[FLGSearchResultViewModel alloc] initWithImageURL:testURL
//                                                        title:@"Lorem fistrum pupita pupita condemor torpedo ese hombree al ataquerl."
//                                                    publisher:@"jgagc jasjg jcagsj "];
    
    ManagedVolume *volume = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    return [[FLGSearchResultViewModel alloc] initWithImageURL:[NSURL URLWithString:volume.imageURL]
                                                        title:volume.title
                                                    publisher:volume.publisher];
}

#pragma mark - Private

- (void) beginNewSearch{
    self.currentPage = 1;
    
    // Lo metemos dentro de este método porque así nos aseguramos de  que lo que va en el bloque se va
    // a ejecutar en el hilo en que hemos creado el "privateContext"
    NSManagedObjectContext *context = self.privateContext;  // Hacemos esto para que no
                                                            //haya un self dentro del bloque
    [context performBlock:^{
        [ManagedVolume deleteAllVolumesInManageObjectContext:context];
        // para que se borren los datos de la busqueda anterior al lanzar una busqueda nueva salvamos el contexto
        [context save:nil];
    }];
    
    // Convertimos una señal fría en una señal multicast
    // publish: permite que haya varios suscriptores a una misma señal
    // connect: nos suscribimos a la señal
    [[[self fetchNextPage] publish] connect];
}

- (void) fetchMoreResults{
    [[[self fetchNextPage] publish] connect];
}

- (RACSignal *) fetchNextPage{
    
    NSManagedObjectContext *context = self.privateContext;  // Hacemos esto para que no
                                                            //haya un self dentro del bloque
    
    return [[[self.client fetchVolumsWithQuery:self.query page:self.currentPage++] doNext:^(FLGResponse *response) {
        [GRTJSONSerialization insertObjectsForEntityName:@"Volume"
                                           fromJSONArray:response.results
                                  inManagedObjectContext:self.privateContext
                                                   error:nil];
        
        // Lo metemos dentro de este método porque así nos aseguramos de  que lo que va en el bloque se va
        // a ejecutar en el hilo en que hemos creado el "privateContext"
        [context performBlockAndWait:^{
            [context save:nil];
        }];
    }] deliverOnMainThread];
}

#pragma mark - Notification
- (void) privateContextDidSave: (NSNotification *) notification{
    NSManagedObjectContext *context = self.mainContext; // Hacemos esto para que no
                                                        //haya un self dentro del bloque
    // Lo metemos dentro de este método porque así nos aseguramos de  que lo que va en el bloque se va
    // a ejecutar en el hilo en que hemos creado el "privateContext"
    [context performBlock:^{
        // Recibimos los cambios en base de datos (que ha realizado el privateContext)
        // y actualizamos el contenido del contexto publico (mainContext)
        [context mergeChangesFromContextDidSaveNotification:notification];
    }];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // Se lanza a mano un evento "sendNext" de una señal manual
    [self.didUpdateResultsSubject sendNext:nil];
}


@end
