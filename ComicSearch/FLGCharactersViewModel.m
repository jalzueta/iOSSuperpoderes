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

@property (strong, nonatomic) RACSubject *didReceiveDetailVolumeSubject;

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
        _didReceiveDetailVolumeSubject = [RACSubject subject];
    }
    return self;
}

- (RACSignal *)didReceiveDetailVolume{
    return self.didReceiveDetailVolumeSubject;
}

- (void)setIdentifier:(NSNumber *)identifier{
    if (![_identifier isEqualToNumber:identifier]) {
        _identifier = identifier;
        NSLog(@"setIdentifier: %@", identifier);
        [self beginNewDetailVolumeRequest];
    }
}

- (void) beginNewDetailVolumeRequest{
    [[[self fetchDetailVolumeWithIdentifier:self.identifier] publish] connect];
}

- (RACSignal *) fetchDetailVolumeWithIdentifier: (NSNumber *) identifier{
    self.client = [FLGComicVineClient new];
    return [[[self.client fetchDetailVolumeWithId:identifier] deliverOnMainThread] doNext:^(FLGResponse *response) {
        FLGVolume *volume = response.results;
        NSMutableArray *characterResults = [NSMutableArray array];
        for (FLGCharacter *character in volume.characters) {
            FLGCharacterResultViewModel *characterResult = [[FLGCharacterResultViewModel alloc] initWithIdentifier:character.identifier
                                                                                                              name:character.name];
            [characterResults addObject:characterResult];
        }
        self.characters = characterResults;
        [self.didReceiveDetailVolumeSubject sendNext:nil];
    }];
}

@end
