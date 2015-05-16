//
//  FLGSearchViewController.m
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSearchViewController.h"
#import "FLGSuggestionsViewController.h"

@interface FLGSearchViewController ()

@end

@implementation FLGSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - Actions

- (IBAction)presentsSuggestions:(id)sender{
    // Instanciomos sugVC
    FLGSuggestionsViewController *suggestionsVC = [FLGSuggestionsViewController new];
    // SearchController presenta la interfaz de busqueda
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:suggestionsVC];
    searchController.searchResultsUpdater = suggestionsVC;
    searchController.hidesNavigationBarDuringPresentation = NO;
    
    // Mostramos el searchController de forma modal
    [self presentViewController:searchController
                       animated:YES
                     completion:nil];
}



@end
