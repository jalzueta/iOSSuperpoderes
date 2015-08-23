//
//  FLGComicVineClient.h
//  ComicSearch
//
//  Created by Javi Alzueta on 16/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface FLGComicVineClient : NSObject

- (RACSignal *) fetchSuggestedVolumesWithQuery: (NSString *) query;

- (RACSignal *) fetchVolumsWithQuery: (NSString *) query page: (NSUInteger) page;
- (RACSignal *) fetchDetailVolumeWithId: (NSNumber *) identifier;

@end
