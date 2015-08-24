//
//  FLGCharacterResultViewModel.m
//  ComicSearch
//
//  Created by Javi Alzueta on 21/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGCharacterResultViewModel.h"

@implementation FLGCharacterResultViewModel

- (instancetype) initWithIdentifier: (NSNumber *) identifier
                               name: (NSString *) name{
    if (self = [super init]) {
        _identifier = [identifier copy];
        _name = [name copy];
    }
    return self;
}

@end
