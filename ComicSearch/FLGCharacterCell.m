//
//  FLGCharacterCell.m
//  ComicSearch
//
//  Created by Javi Alzueta on 21/8/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGCharacterCell.h"
#import "FLGCharacterResultViewModel.h"

@interface FLGCharacterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;

@end

@implementation FLGCharacterCell

- (void) configureWithCharacterResult:(FLGCharacterResultViewModel *)characterResult{
//    [self.coverImageView setImageWithURL:searchResult.imageURL]; // Metodo de AFNetworking: realiza la descarga en segundo plano
    self.nameLabel.text = characterResult.name;
    self.realNameLabel.text = [NSString stringWithFormat:@"%@", characterResult.identifier];
}

- (void) prepareForReuse{
    [super prepareForReuse];
    // Cancelamos la peticion de descarga de la imagen
//    [self.coverImageView cancelImageRequestOperation];
    self.characterImageView.image = nil;
    self.nameLabel.text = nil;
    self.realNameLabel.text = nil;
}

@end
