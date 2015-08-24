//
//  FLGSearchViewController.m
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSearchViewController.h"
#import "FLGSuggestionsViewController.h"

#import "FLGSearchViewModel.h"
#import "FLGSearchResultCell.h"
#import "FLGSearchResultViewModel.h"

#import "FLGCharactersViewController.h"
#import "FLGCharactersViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FLGSearchViewController ()<SuggestionsViewControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) FLGSearchViewModel *viewModel;

@end

@implementation FLGSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [FLGSearchViewModel new];
    
    @weakify(self);
    // Nos suscribimos a la señal de aviso de que los resultados de busqueda han cambiado: esta señal está en el SearchViewModel como property publica
    [self.viewModel.didUpdateResults subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.numberOfResults;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FLGSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FLGSearchResultCell"];
    
    FLGSearchResultViewModel *result = [self.viewModel resultAtIndex:indexPath.row];
    
    [cell configureWithSearchResult:result];
    
    return cell;
}

// Para la paginacion de resultados de busqueda
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == (self.viewModel.numberOfResults -1)) {
        [self.viewModel fetchMoreResults];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FLGCharactersViewController *charactersViewController = (FLGCharactersViewController *)segue.destinationViewController;
    FLGSearchResultViewModel *selectedSearchResultViewModel = (FLGSearchResultViewModel *)[self.viewModel resultAtIndex:[self.tableView indexPathForSelectedRow].row];
    FLGCharactersViewModel *characterViewModel = charactersViewController.viewModel;
    characterViewModel.identifier = selectedSearchResultViewModel.identifier;
}

#pragma mark - Actions

- (IBAction)presentsSuggestions:(id)sender{
    // Instanciomos sugVC
    FLGSuggestionsViewController *suggestionsVC = [FLGSuggestionsViewController new];
    suggestionsVC.delegate = self;
    
    // SearchController presenta la interfaz de busqueda
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:suggestionsVC];
    searchController.searchResultsUpdater = suggestionsVC;
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.searchBar.delegate = self;
    
    // Mostramos el searchController de forma modal
    [self presentViewController:searchController
                       animated:YES
                     completion:nil];
}

#pragma mark - SuggestionsViewControllerDelegate

- (void) suggestionsViewController:(FLGSuggestionsViewController *)suggestionsViewController didSelectSuggestion:(NSString *)suggestion{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    // Actualizamos la "query" de nuestro viewModel.
    // El se encargara de observar esta propiedad y lanzar una nueva búsqueda
    self.viewModel.query = suggestion;
}

#pragma mark - UISearchBarDelegate
// Evento de pulsacion del boton "search" del teclado
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    // Actualizamos la "query" de nuestro viewModel.
    // El se encargara de observar esta propiedad y lanzar una nueva búsqueda
    self.viewModel.query = searchBar.text;
}

@end
