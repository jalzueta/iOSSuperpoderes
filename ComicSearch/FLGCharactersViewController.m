//
//  FLGCharactersViewController.m
//  ComicSearch
//
//  Created by Javi Alzueta on 20/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGCharactersViewController.h"
#import "FLGCharactersViewModel.h"
#import "FLGCharacterCell.h"
#import "FLGCharacterResultViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FLGCharacter.h"

static NSString *const reuseIdentifier = @"FLGCharacterCell";

@interface FLGCharactersViewController ()

@end

@implementation FLGCharactersViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _viewModel = [FLGCharactersViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [self.viewModel.didReceiveDetailVolume subscribeNext:^(id x) {
        @strongify(self);
        [self reloadData];
    }];
}

- (void) reloadData{
    NSLog(@"Reload Data - numberOfCharacters: %lul", (unsigned long)self.viewModel.numberOfCharacters);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.numberOfCharacters;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLGCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLGCharacterCell"];
    
    NSLog(@"NumberOfCharacters: %lu", (unsigned long)self.viewModel.numberOfCharacters);
    NSLog(@"Row: %lu", (unsigned long)indexPath.row);
    if (self.viewModel.numberOfCharacters > indexPath.row) {
        FLGCharacterResultViewModel *character = [self.viewModel characterAtIndex:indexPath.row];
        [cell configureWithCharacterResult:character];
    }
    
    return cell;
}

@end
