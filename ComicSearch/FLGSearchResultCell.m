//
//  FLGSearchResultCell.m
//  ComicSearch
//
//  Created by Javi Alzueta on 17/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSearchResultCell.h"
#import "FLGSearchResultViewModel.h"

#import <AFNetworking/UIKit+AFNetworking.h> // Import para la descarga de la imagen en segundo plano

@interface FLGSearchResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;

@end

@implementation FLGSearchResultCell

- (void) configureWithSearchResult:(FLGSearchResultViewModel *)searchResult{
    [self.coverImageView setImageWithURL:searchResult.imageURL]; // Metodo de AFNetworking: realiza la descarga en segundo plano
    self.titleLabel.text = searchResult.title;
    self.publisherLabel.text = [NSString stringWithFormat:@"%@", searchResult.identifier];//searchResult.publisher;
}

- (void) prepareForReuse{
    [super prepareForReuse];
    // Cancelamos la peticion de descarga de la imagen
    [self.coverImageView cancelImageRequestOperation];
    self.coverImageView.image = nil;
    self.titleLabel.text = nil;
    self.publisherLabel.text = nil;
}

@end
