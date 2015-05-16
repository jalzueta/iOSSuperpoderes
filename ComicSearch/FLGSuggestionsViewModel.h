//
//  FLGSuggestionsViewModel.h
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLGSuggestionsViewModel : NSObject

// NSString lectura/escritura de entrada de la perticion
@property (copy, nonatomic) NSString *query;

@property (readonly, nonatomic) NSUInteger numberOfSuggestions;

- (NSString *)suggestionAtIndex:(NSUInteger)index;

@end
