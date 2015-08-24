//
//  FLGCharacterCell.m
//  ComicSearch
//
//  Created by Javi Alzueta on 21/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGCharacterCell.h"
#import "FLGCharacterResultViewModel.h"
#import "FLGDetailCharacterResultViewModel.h"

#import <AFNetworking/UIKit+AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FLGCharacterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;

@property (strong, nonatomic) FLGDetailCharacterResultViewModel *detailCharacterViewModel;
@property (nonatomic) BOOL cancelled;

@end

@implementation FLGCharacterCell

- (void) configureWithCharacterResult:(FLGCharacterResultViewModel *)characterResult{
    self.nameLabel.text = characterResult.name;
    self.realNameLabel.text = @"";
    self.cancelled = NO;
    
    // Descarga del objeto personaje
    self.detailCharacterViewModel = [[FLGDetailCharacterResultViewModel alloc] initWithIdentifier:characterResult.identifier];
    @weakify(self);
    [[self.detailCharacterViewModel.didReceiveDetailCharacter takeUntil:[RACObserve(self, cancelled) ignore:@NO]] subscribeNext:^(id x) {
        @strongify(self);
        [self reloadData];
    }];
}

- (void) reloadData{
    self.nameLabel.text = self.detailCharacterViewModel.name;
    self.realNameLabel.text = self.detailCharacterViewModel.realName;
    [self.characterImageView setImageWithURL:self.detailCharacterViewModel.imageURL];
}

- (void) prepareForReuse{
    [super prepareForReuse];
    self.cancelled = YES;
    [self.characterImageView cancelImageRequestOperation];
    
    self.detailCharacterViewModel = nil;
    self.characterImageView.image = nil;
    self.nameLabel.text = nil;
    self.realNameLabel.text = nil;
}

@end
