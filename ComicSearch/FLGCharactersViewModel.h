//
//  FLGCharactersViewModel.h
//  ComicSearch
//
//  Created by Javi Alzueta on 20/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@class FLGCharacterResultViewModel;

@interface FLGCharactersViewModel : NSObject

@property (copy, nonatomic) NSNumber *identifier;

@property (readonly, nonatomic) NSUInteger numberOfCharacters;
@property (strong, nonatomic, readonly) RACSignal *didReceiveDetailVolume;

- (FLGCharacterResultViewModel *)characterAtIndex:(NSUInteger)index;

@end
