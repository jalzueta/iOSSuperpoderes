//
//  FLGVolume.h
//  ComicSearch
//
//  Created by Javi Alzueta on 16/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FLGVolume : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *title;

@end
