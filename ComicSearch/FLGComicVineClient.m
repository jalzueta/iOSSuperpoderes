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
#import "FLGResponse.h"
#import "FLGVolume.h"

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
    NSDictionary *parameters = @{
                                 @"api_key" : APIKey,
                                 @"format" : format,
                                 @"field_list" : @"name", //campos que queremos que nos devuelva la peticion
                                 @"limit" : @10,
                                 @"page" : @1,
                                 @"query": query,
                                 @"resources" : @"volume" // tipo de recurso
                                 };
    
    return  [self GET:@"search" parameters:parameters resultClass:[FLGVolume class]];
}

- (RACSignal *) fecthVolumsWithQuery: (NSString *) query page: (NSUInteger) page{
    NSDictionary *parameters = @{
                                 @"api_key" : APIKey,
                                 @"format" : format,
                                 @"field_list" : @"id,image,name,publisher", //campos que queremos que nos devuelva la peticion
                                 @"limit" : @20,
                                 @"page" : @(page),
                                 @"query": query,
                                 @"resources" : @"volume" // tipo de recurso
                                 };
    
    // Pasamos "Nil" (mayúsculas, porque espera una clase) en la resourceClass porque no queremos que haga ninguna transformación con los datos, solo con los metadatos
    return  [self GET:@"search" parameters:parameters resultClass:Nil];
}

#pragma mark - Private

- (RACSignal *) GET: (NSString *) path
         parameters: (NSDictionary *) parameters
        resultClass: (Class) resultClass{
    return [[self GET:path
          parameters:parameters] map:^id(NSDictionary *JSONDictionary) {
        // Metodo a través del cual vamos a mapear el JSON a un objeto de la clase "resultClass"
        return [FLGResponse responseWithJSONDictionary:JSONDictionary
                                           resultClass:resultClass];
    }];
}

- (RACSignal *) GET: (NSString *) path
         parameters: (NSDictionary *) parameters{
    
    // Al hacer este "return" se está creando la suscripción
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // Todo lo de aqui dentro solo se ejecuta si hay alguien suscrito
        AFHTTPRequestOperation *operation = [self.requestManager GET:path
                                                          parameters:parameters
                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                 [subscriber sendNext:responseObject];
                                                                 // Este "sendNext" es el que desencadena todo lo demas: transformaciones/mapeados del JSON en objetos y repintado de tablas y demás
                                                                 [subscriber sendCompleted];
                                                             }
                                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                 [subscriber sendError:error];
                                                             }];
        
        // Devuelve un objeto a través del cual detectamos cuando hay una des-suscripcion a esta señal
        // Una des-suscripcion ocurre por ejemplo cuando se está "observando" una property mediante binding
        // y el viewController desaparece de la pantalla con un pop
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }] deliverOn:[RACScheduler scheduler]]; // deliverOn:[RACScheduler scheduler] -> Con esto mandamos la respuesta de la señal a un thread secundario, incluido el tema de actualización de la tabla.
    // Habrá que volver al thread principal para el refresco de la tabla
}


@end
