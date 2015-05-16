//
//  FLGSuggestionsViewController.m
//  ComicSearch
//
//  Created by Javi Alzueta on 15/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSuggestionsViewController.h"
#import "FLGSuggestionsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const reuseIdentifier = @"cell";

@interface FLGSuggestionsViewController ()

@property (strong, nonatomic) FLGSuggestionsViewModel *viewModel;

@end

@implementation FLGSuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Registramos el tipo de celda de la tabla para el "reuseIdentifier"
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:reuseIdentifier];
    
    self.viewModel = [FLGSuggestionsViewModel new];
    
    // Eliminamos referencias circulares, muy comun al trabajar con bloques
    @weakify(self);
    // Nos suscribimos a la señal de aviso de que las sugerencias han cambiado
    [self.viewModel.didUpdateSuggestionsSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.numberOfSuggestions;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Vamos a usar una celda con estilo "por defecto" - Por eso nos vale el método nuevo de dejarle al sistema generar la celda si no existe, haciendo uso de la clase registrada
    
    cell.textLabel.text = [self.viewModel suggestionAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSString *suggestion = [self.viewModel suggestionAtIndex:indexPath.row];
    [self.delegate suggestionsViewController:self didSelectSuggestion:suggestion];
}

#pragma mark - UISearchResultsUpdating

- (void) updateSearchResultsForSearchController:(UISearchController *)searchController {
    // TODO: implementar esto!
    // FIXME: hola
    
    // Le pasamos a viewModel el texto que hay en la barra de búsqueda
    self.viewModel.query = searchController.searchBar.text;
}

@end
