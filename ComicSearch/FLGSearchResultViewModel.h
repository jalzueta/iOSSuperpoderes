//
//  FLGSearchResultViewModel.h
//  ComicSearch
//
//  Created by Javi Alzueta on 17/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLGSearchResultViewModel : NSObject

// Ponemos la URL de la imagen por dos motivos:
// 1. No queremos poner nada de UIKit (compatibilidad con OSX)
// 2. No queremos poner nada de logica de pantalla en el ViewModel
@property (copy, nonatomic, readonly) NSURL *imageURL;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *publisher;

- (instancetype) initWithImageURL: (NSURL *) imageURL
                            title: (NSString *) title
                        publisher: (NSString *) publisher;

@end
