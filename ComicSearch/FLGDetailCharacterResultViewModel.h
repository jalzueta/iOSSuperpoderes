//
//  FLGDetailCharacterResultViewModel.h
//  ComicSearch
//
//  Created by Javi Alzueta on 23/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface FLGDetailCharacterResultViewModel : NSObject

@property (strong, nonatomic, readonly) RACSignal *didReceiveDetailCharacter;

@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *realName;
@property (copy, nonatomic, readonly) NSURL *imageURL;

- (instancetype) initWithIdentifier: (NSNumber *) identifier;

@end
