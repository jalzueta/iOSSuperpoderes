//
//  FLGVolume.m
//  ComicSearch
//
//  Created by Javi Alzueta on 16/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGVolume.h"
#import "FLGCharacter.h"

@implementation FLGVolume

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"identifier" : @"id",
             @"title" : @"name", // Le asignamos el valor del atributo "name" del JSON a la propiedad "title" de FLGVolume
             @"characters" : @"characters"
             };
}

+ (NSValueTransformer *)charactersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[FLGCharacter class]];
}

@end
