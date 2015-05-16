//
//  FLGSuggestionsViewModel.h
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface FLGSuggestionsViewModel : NSObject

// NSString lectura/escritura de entrada de la perticion
@property (copy, nonatomic) NSString *query;

@property (readonly, nonatomic) NSUInteger numberOfSuggestions;

// Señal a la que te puedes suscribir y va a enviar un evento "next" cada vez que se actualicen las sugerencias
@property (strong, nonatomic, readonly) RACSignal *didUpdateSuggestionsSignal;

- (NSString *)suggestionAtIndex:(NSUInteger)index;

@end
