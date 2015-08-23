//
//  FLGCharacter.m
//  ComicSearch
//
//  Created by Javi Alzueta on 20/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGCharacter.h"

@implementation FLGCharacter

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"identifier" : @"id",
             @"name" : @"name"
             };
}

@end
