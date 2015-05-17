//
//  FLGSearchResultCell.h
//  ComicSearch
//
//  Created by Javi Alzueta on 17/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLGSearchResultViewModel;

@interface FLGSearchResultCell : UITableViewCell

- (void) configureWithSearchResult: (FLGSearchResultViewModel *) searchResult;

@end
