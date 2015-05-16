//
//  FLGSuggestionsViewModel.m
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSuggestionsViewModel.h"

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
        _suggestions = @[@"Hello",
                         @"Bye",
                         @"See you"];
    }
    return self;
}

@end
