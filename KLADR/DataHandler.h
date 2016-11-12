//
//  DataHandler.h
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>
#import "KLADRModels.h"

@interface DataHandler : NSObject

+ (FMDatabase *) db;
+ (NSOperationQueue *) dbOperationsQueue;
+ (void) preload;

+ (void) loadRegions;
+ (void) loadTownsForRegion:(Region *)region;
+ (void) loadStreetsForTown:(Town *)town;
+ (void) loadHousesForStreet:(Street *)street;

@end
