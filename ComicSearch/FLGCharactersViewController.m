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
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.numberOfCharacters;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLGCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLGCharacterCell"];
    
    FLGCharacterResultViewModel *character = [self.viewModel characterAtIndex:indexPath.row];
    [cell configureWithCharacterResult:character];
    
    return cell;
}

@end
