//
//  FLGCharactersViewModel.m
//  ComicSearch
//
//  Created by Javi Alzueta on 20/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGCharactersViewModel.h"
#import "FLGCharacterResultViewModel.h"
#import "FLGCharacter.h"
#import "FLGCharacterResultViewModel.h"
#import "FLGComicVineClient.h"
#import "FLGResponse.h"
#import "FLGCharacter.h"
#import "FLGVolume.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FLGCharactersViewModel ()

@property (copy, nonatomic) NSArray *characters;
@property (strong, nonatomic) FLGComicVineClient *client;

@end

@implementation FLGCharactersViewModel

- (NSUInteger)numberOfCharacters{
    return self.characters.count;
}

- (FLGCharacterResultViewModel *)characterAtIndex:(NSUInteger)index{
    return [self.characters objectAtIndex: index];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        RACSignal *input = RACObserve(self, identifier);
        @weakify(self);
        RACSignal *charactersSignal = [input flattenMap:^RACStream *(NSNumber *identifier) {
            @strongify(self);
            return [self fetchDetailVolumeWithIdentifier: identifier];
        }];
        RAC(self, characters) = [charactersSignal catch:^RACSignal *(NSError *error) {
            return [RACSignal return:@[error.localizedDescription]];
        }];
        _didReceiveDetailVolume = [RACObserve(self, characters) map:^id(id value) {
            return nil;
        }];
    }
    return self;
}

- (RACSignal *) fetchDetailVolumeWithIdentifier: (NSNumber *) identifier{
    self.client = [FLGComicVineClient new];
    return [[[self.client fetchDetailVolumeWithId:identifier] map:^id(FLGResponse *response) {
        FLGVolume *volume = response.results;
//        return volume.characters;
        NSMutableArray *characterResults = [NSMutableArray array];
        for (FLGCharacter *character in volume.characters) {
            FLGCharacterResultViewModel *characterResult = [[FLGCharacterResultViewModel alloc] initWithIdentifier:character.identifier
                                                                                                              name:character.name];
            [characterResults addObject:characterResult];
        }
        return  characterResults;
    }] deliverOnMainThread];
}

@end
