//
//  FLGSuggestionsViewModel.m
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSuggestionsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FLGComicVineClient.h"
#import "FLGResponse.h"
#import "FLGVolume.h"

@interface FLGSuggestionsViewModel ()

// Todas las propiedades que implementen NSCopying hay que ponerlas como "copy"
@property (copy, nonatomic) NSArray *suggestions;

@end

@implementation FLGSuggestionsViewModel

- (NSUInteger)numberOfSuggestions{
    return self.suggestions.count;
}

- (NSString *)suggestionAtIndex:(NSUInteger)index{
    return [self.suggestions objectAtIndex: index];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // KVO a través de ReactiveCocoa.
        // Devuelve una señal caliente con el flujo de datos de query
        RACSignal *input = RACObserve(self, query);
        
        // Añadimos un filtro para que solo funcione para alores de "query" de al menos 3 caracteres
        input = [input filter:^BOOL(NSString *value) {
            return value.length > 2;
        }];
        
        // Limitamos el numero de peticiones por tiempo.
        // Aunque haya eventos de variación en query, no se van a lanzar hasta que pase el intervalo de tiempo configurado sin que haya una nueva entrada
        input = [input throttle:.4];
        
        // Ponemos nombre a la señal, para depuración
        // Configuramos el loggeo automático de todos susu valores, para depuración
//        [[input setNameWithFormat:@"input"] logAll];
        
//        [input subscribeNext:^(NSString *value) {
//            NSLog(@"input: %@", value);
//        }];
        
        // Nos conectamos a la señal
//        [[input publish] connect];
        
        // Encadenamos señales - nos suscribimos con binding
        FLGSuggestionsViewModel * __weak weakSelf = self;
        // Atajo de ReactiveCocoa: @weakify(self);
        RACSignal *suggestionsSignal = [input flattenMap:^RACStream *(NSString *query) {
            FLGSuggestionsViewModel * __strong strongSelf = weakSelf;
            // Atajo de ReactiveCocoa: @strongify(self);
            return [strongSelf fetchSuggestionsWithQuery:query];
        }];
        
        // Hacemos un binding
        RAC(self, suggestions) = suggestionsSignal;
        
        // Como el evento "next" no queremos que envie ningun valor asociado, aprovechamos la señal "suggestionsSignal", pero la modificamos para que no lleve ningún valor asociado y se la asignamos a didUpdateSuggestionsSignal (mediante map)
        _didUpdateSuggestionsSignal = [suggestionsSignal map:^id(id value) {
            return nil;
        }];
        // Esta sería una forma abreviada para hacer lo mismo (sin bloques)
//        _didUpdateSuggestionsSignal = [suggestionsSignal mapReplace:nil];
        
    }
    return self;
}

#pragma mark - Private

- (RACSignal *)fetchSuggestionsWithQuery: (NSString *) query{
    FLGComicVineClient *client = [FLGComicVineClient new];
    
    return [[client fetchSuggestedVolumesWithQuery:query] map:^id(FLGResponse *response) {
        NSArray *volumes = response.results;
        NSMutableArray *titles = [NSMutableArray array];
        for (FLGVolume *volume in volumes) {
            if ([titles containsObject:volume.title]) {
                continue;
            }
            [titles addObject:volume.title];
        }
        
        return  titles;
        
        // Equivalente al bucle "for in" pero con RAC
//        return [volumes.rac_sequence map:^id(FLGVolume *value) {
//            return value.title;
//        }].array;
        
        // Equivalente al bucle "for in" con filtrado de repetidos pero con RAC
//        return [volumes.rac_sequence foldLeftWithStart:[NSMutableArray array]
//                                                reduce:^id(NSMutableArray *titles, FLGVolume *value) {
//                                                    if (![titles containsObject:value.title]) {
//                                                        [titles addObject:value.title];
//                                                    }
//                                                    return titles;
//                                                }];
   
    }];
}

@end
