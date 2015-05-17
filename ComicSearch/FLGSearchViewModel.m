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

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FLGSearchViewModel ()

@property (strong, nonatomic) FLGComicVineClient *client;
@property (nonatomic) NSUInteger currentPage; // Muchos servicos web inician su paginacion a "1"

@end

@implementation FLGSearchViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [FLGComicVineClient new];
        _currentPage = 1;
        
        // Observamos a query, ignorando valores "nil" y cadenas vacias
        RACSignal *input = [RACObserve(self, query) filter:^BOOL(NSString *value) {
            return value.length > 0;
        }];
    }
    return self;
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

- (RACSignal *) fetchNextPage{
    // TODO: implementar
    return nil;
}

@end
