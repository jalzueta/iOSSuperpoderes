//
//  FLGCharacterResultViewModel.h
//  ComicSearch
//
//  Created by Javi Alzueta on 21/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLGCharacterResultViewModel : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSNumber *identifier;

- (instancetype) initWithIdentifier: (NSNumber *) identifier
                               name: (NSString *) name;

@end
