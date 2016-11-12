//
//  CustomORM.h
//  KLADR
//
//  Created by Konstantin on 12/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/KLADRModels.h"

@interface KladrORM : NSObject

- (id) initWithPath:(NSString *)path;

- (void) loadLocationTypesForBlock:(void(^)(NSArray <LocationType *> *)) locationTypesHandler;
- (void) loadRegionsForBlock:(void(^)(NSArray <Region *> *)) regionsHandler;
- (void) loadTownsOfRegion:(Region *)region forBlock:(void(^)(NSArray <Town *> *)) townsHandler;
- (void) loadStreetsOfTown:(Town *)town forBlock:(void(^)(NSArray <Street *> *)) streetsHandler;
- (void) loadHousesOfStreet:(Street *)street forBlock:(void(^)(NSArray <House *> *)) housesHandler;

@end
