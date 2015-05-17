//
//  FLGSearchViewModel.h
//  ComicSearch
//
//  Created by Javi Alzueta on 17/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLGSearchResultViewModel;
@class RACSignal;

@interface FLGSearchViewModel : NSObject

@property (copy, nonatomic) NSString *query;

@property (nonatomic, readonly) NSUInteger numberOfResults;

@property (strong, nonatomic, readonly) RACSignal *didUpdateResults;

- (FLGSearchResultViewModel *) resultAtIndex: (NSUInteger) index;

@end
