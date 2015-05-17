//
//  ManagedVolume.h
//  ComicSearch
//
//  Created by Javi Alzueta on 17/5/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ManagedVolume : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSDate * insertionDate;

+ (NSFetchRequest *)fetchRequestForAllVolumes;
+ (void) deleteAllVolumesInManageObjectContext: (NSManagedObjectContext *) managedContext;

@end
