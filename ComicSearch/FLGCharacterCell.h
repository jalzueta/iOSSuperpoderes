//
//  FLGCharacterCell.h
//  ComicSearch
//
//  Created by Javi Alzueta on 21/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLGCharacterResultViewModel;

@interface FLGCharacterCell : UITableViewCell

- (void) configureWithCharacterResult:(FLGCharacterResultViewModel *)characterResult;

@end
