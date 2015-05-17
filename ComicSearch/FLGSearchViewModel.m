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

@interface FLGSearchViewModel ()

@property (strong, nonatomic) FLGComicVineClient *client;
@property (nonatomic) NSUInteger currentPage; // Muchos servicos web inician su paginacion a "1"

// Contextos privado (escritura/borrado) y principal (lectura)
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

@end

@implementation FLGSearchViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [FLGComicVineClient new];
        _currentPage = 1;
    }
    return self;
}

- (void)setQuery:(NSString *)query{
    if (![_query isEqualToString:query]) {
        _query = [query copy];
        [self beginNewSearch];
    }
}

- (NSUInteger)numberOfResults{
    // FIXME: temporary
    return 1;
}

- (FLGSearchResultViewModel *) resultAtIndex:(NSUInteger)index{
    // FIXME: temporary
//    NSURL *testURL = [NSURL URLWithString:@"http://static.comicvine.com/uploads/scale_avatar/6/67663/2046031-01.jpg"];
//    return [[FLGSearchResultViewModel alloc] initWithImageURL:testURL
//                                                        title:@"Lorem fistrum pupita pupita condemor torpedo ese hombree al ataquerl."
//                                                    publisher:@"jgagc jasjg jcagsj "];
    
    // TODO: implementar
    return nil;
}

#pragma mark - Private

- (void) beginNewSearch{
    self.currentPage = 1;
    
    // Lo metemos dentro de este método porque así nos aseguramos de  que lo que va en el bloque se va
    // a ejecutar en el hilo en que hemos creado el "privateContext"
    NSManagedObjectContext *context = self.privateContext; // Hacemos esto para que no haya un self dentro del bloque
    [context performBlock:^{
        [ManagedVolume deleteAllVolumesInManageObjectContext:context];
    }];
    
    // Convertimos una señal fría en una señal multicast
    // publish: permite que haya varios suscriptores a una misma señal
    // connect: nos suscribimos a la señal
    [[[self fetchNextPage] publish] connect];
}

- (RACSignal *) fetchNextPage{
    return [[[self.client fetchVolumsWithQuery:self.query page:self.currentPage++] doNext:^(id x) {
        // TODO: save data
    }] deliverOnMainThread];
}


@end
