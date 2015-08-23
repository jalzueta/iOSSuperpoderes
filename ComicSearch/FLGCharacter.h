//
//  FLGCharacter.h
//  ComicSearch
//
//  Created by Javi Alzueta on 20/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FLGCharacter : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *name;

@end
