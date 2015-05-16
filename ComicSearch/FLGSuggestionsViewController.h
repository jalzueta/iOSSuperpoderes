//
//  FLGSuggestionsViewController.h
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuggestionsViewControllerDelegate;

@interface FLGSuggestionsViewController : UITableViewController<UISearchResultsUpdating>

@property (weak, nonatomic) id<SuggestionsViewControllerDelegate> delegate;

@end

@protocol SuggestionsViewControllerDelegate <NSObject>

- (void) suggestionsViewController: (FLGSuggestionsViewController *) suggestionsViewController didSelectSuggestion: (NSString *)suggestion;

@end

