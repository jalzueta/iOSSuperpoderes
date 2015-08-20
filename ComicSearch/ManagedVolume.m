//
//  ManagedVolume.m
//  ComicSearch
//
//  Created by Javi Alzueta on 17/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "ManagedVolume.h"


@implementation ManagedVolume

@dynamic identifier;
@dynamic imageURL;
@dynamic title;
@dynamic publisher;
@dynamic insertionDate;

// Metodo en el que entra cuando se inserta un objeto en Core Data
- (void)awakeFromInsert{
    [super awakeFromInsert];
    self.insertionDate = [NSDate date];
}

+ (NSFetchRequest *)fetchRequestForAllVolumes{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Volume"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"insertionDate"
                                                                     ascending:YES];
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.fetchBatchSize = 20; //mismo tamaño que en la paginacion
    
    return fetchRequest;
}

+ (void) deleteAllVolumesInManageObjectContext: (NSManagedObjectContext *) managedObjectContext{
    NSFetchRequest *fecthRequest = [self fetchRequestForAllVolumes];
    // Le decimos que no queremos que traiga de Core Data los valores de las properties, no hacen falta para borrar los registros de Core Data y es mucho más rápido
    fecthRequest.includesPropertyValues = NO;
    
    NSArray *volumes = [managedObjectContext executeFetchRequest:fecthRequest
                                                           error:NULL];
    
    for (NSManagedObject *v in volumes) {
        [managedObjectContext deleteObject:v];
    }
}

@end
