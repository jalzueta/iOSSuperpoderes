//
//  FLGCharactersViewController.h
//  ComicSearch
//
//  Created by Javi Alzueta on 20/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLGCharactersViewModel;

@interface FLGCharactersViewController : UITableViewController

@property (strong, nonatomic) FLGCharactersViewModel *viewModel;

@end
