//
//  FLGDetailCharacterResultViewModel.m
//  ComicSearch
//
//  Created by Javi Alzueta on 23/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGDetailCharacterResultViewModel.h"
#import "FLGComicVineClient.h"
#import "FLGResponse.h"
#import "FLGCharacter.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FLGDetailCharacterResultViewModel ()

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *realName;
@property (copy, nonatomic) NSURL *imageURL;

@property (strong, nonatomic) FLGComicVineClient *client;
@property (strong, nonatomic) RACSubject *didReceiveDetailCharacterSubject;
@property (strong, nonatomic) RACSignal *detailCharacterSignal;

@end

@implementation FLGDetailCharacterResultViewModel

- (instancetype) initWithIdentifier: (NSNumber *) identifier{
    if (self = [super init]) {
        _identifier = [identifier copy];
        _didReceiveDetailCharacterSubject = [RACSubject subject];
        [self beginNewDetailCharacterRequest];
    }
    return self;
}

- (RACSignal *)didReceiveDetailCharacter{
    return self.didReceiveDetailCharacterSubject;
}

- (void) beginNewDetailCharacterRequest{
    [[[self fetchDetailCharacterWithIdentifier:self.identifier] publish] connect];
}

- (RACSignal *) fetchDetailCharacterWithIdentifier: (NSNumber *) identifier{
    self.client = [FLGComicVineClient new];
    RACSignal *detailCharacterSignal = [[[self.client fetchDetailCharacterWithId:identifier] deliverOnMainThread] doNext:^(FLGResponse *response) {
        FLGCharacter *character = response.results;
        self.name = character.name;
        self.realName = character.realName;
        self.imageURL = character.imageURL;
        [self.didReceiveDetailCharacterSubject sendNext:nil];
    }];
    
    return detailCharacterSignal;
}


@end
