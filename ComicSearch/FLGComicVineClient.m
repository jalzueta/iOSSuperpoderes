//
//  FLGComicVineClient.m
//  ComicSearch
//
//  Created by Javi Alzueta on 16/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGComicVineClient.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const APIKey = @"8eacfa46646cf4888066fed652021d901d19cc89";
static NSString * const format = @"json";

@interface FLGComicVineClient ()

// Cliente HTTP
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

@end

@implementation FLGComicVineClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]
                           initWithBaseURL:[NSURL URLWithString:@"http://www.comicvine.com/api"]];
    }
    return self;
}

- (RACSignal *) fetchSuggestedVolumesWithQuery: (NSString *) query{
    // TODO: implement
    NSDictionary *parameters = @{
                                 @"api_key" : APIKey,
                                 @"format" : format,
                                 @"field_list" : @"name", //campos que queremos que nos devuelva la peticion
                                 @"limit" : @10,
                                 @"page" : @1,
                                 @"query": query,
                                 @"resources" : @"volume" // tipo de recurso
                                 };
    
    return [self GET:@"search" parameters:parameters];
}

#pragma mark - Private

- (RACSignal *) GET: (NSString *) path
         parameters: (NSDictionary *) parameters{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // TODO: implementar
        AFHTTPRequestOperation *operation = [self.requestManager GET:path
                                                          parameters:parameters
                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                 [subscriber sendNext:responseObject];
                                                                 [subscriber sendCompleted];
                                                             }
                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                 [subscriber sendError:error];
                                                             }];
        
        // Devuelve un objeto a través del cual detectamos cuando hay una des-suscripcion a esta señal
        // Una des-suscripcion ocurre por ejemplo cuando se está "observando" una property mediante binding
        // y el viewController desaparece de la pantalla con un pop
        return [RACDisposable disposableWithBlock:^{
            // Si hay una des-subscripción, se cancela la peticion GET
            [operation cancel];
        }];
    }];
}


@end
