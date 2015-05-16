//
//  FLGResponse.h
//  ComicSearch
//
//  Created by Javi Alzueta on 16/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FLGResponse : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSNumber *statusCode;
@property (copy, nonatomic, readonly) NSString *errorMessage;
@property (copy, nonatomic, readonly) NSNumber *numberOfTotalResults;
@property (copy, nonatomic, readonly) NSNumber *offset;
@property (strong, nonatomic, readonly) id results;

+ (instancetype) responseWithJSONDictionary: (NSDictionary *) JSONDictionary
                                resultClass: (Class) resultClass;

@end
