//
//  CustomORM.m
//  KLADR
//
//  Created by Konstantin on 12/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrORM.h"
#import "FMDB/FMDatabase.h"

@implementation KladrORM{
    FMDatabase *_db;
    NSOperationQueue *_dbOperationsQueue;
}

- (id) initWithPath:(NSString *)path{
    self = [super init];
    if (self){
        _db = [[FMDatabase alloc] initWithPath:path];
        _dbOperationsQueue = [[NSOperationQueue alloc] init];
        [_dbOperationsQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void) loadLocationTypesForBlock:(void (^)(NSArray<LocationType *> *))locationTypesHandler{
    [_dbOperationsQueue addOperationWithBlock:^{
        NSString *query =   @"SELECT \"PKUID\", \"SOCRNAME\", \"SCNAME\", \"LEVEL\", \"KOD_T_ST\" "
        "FROM \"socrbase_tbl\"";
        NSMutableArray <LocationType *> *locations = [[NSMutableArray alloc] init];
        
        [_db open];
        FMResultSet *resultSet = [_db executeQuery:query];
        while([resultSet next]){
            [locations addObject:[[LocationType alloc] initWithId:[resultSet longForColumn:@"PKUID"]
                                                     abbreviation:[resultSet stringForColumn:@"SOCRNAME"]
                                                         fullName:[resultSet stringForColumn:@"SCNAME"]
                                                            level:[resultSet longForColumn:@"LEVEL"]
                                                             code:[resultSet stringForColumn:@"KOD_T_ST"]]];
        }
        [_db close];
        
        locationTypesHandler(locations);
    }];
}

- (void) loadRegionsForBlock:(void (^)(NSArray<Region *> *))regionsHandler{
    [_dbOperationsQueue addOperationWithBlock:^{
        NSString *query = @"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"INDEX\", \"GNINMB\", \"OCATD\" "
        "FROM \"kladr_tbl\" "
        "WHERE \"OCATD\" != \"\" AND \"OCATD\" \% 1000000000 = 0";
        NSMutableArray<Region *> *regions = [[NSMutableArray alloc] init];
        
        [_db open];
        FMResultSet *resultSet = [_db executeQuery:query];
        while([resultSet next]){
            [regions addObject:[[Region alloc] initWithId:[resultSet longForColumn:@"PKUID"]
                                                     name:[resultSet stringForColumn:@"NAME"]
                                                     code:[resultSet stringForColumn:@"CODE"]
                                                    ocatd:[resultSet stringForColumn:@"OCATD"]
                                             locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]]];
        }
        [_db close];
        
        regionsHandler(regions);
    }];
}

- (void) loadTownsOfRegion:(Region *)region forBlock:(void (^)(NSArray<Town *> *))townsHandler{
    [_dbOperationsQueue addOperationWithBlock:^{
        NSString *query = [NSString stringWithFormat:@"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"INDEX\", \"GNINMB\", \"OCATD\" "
                           @"FROM \"kladr_tbl\" "
                           @"WHERE \"OCATD\" %% 1000000000 != 0 AND \"OCATD\" / 1000000000 = %@", region.regionCode];
        NSMutableArray<Town *> *towns = [[NSMutableArray alloc] init];
        
        [_db open];
        FMResultSet *resultSet = [_db executeQuery:query];
        while([resultSet next]){
            [towns addObject:[[Town alloc] initWithId:[resultSet longForColumn:@"PKUID"]
                                                name:[resultSet stringForColumn:@"NAME"]
                                                code:[resultSet stringForColumn:@"CODE"]
                                               ocatd:[resultSet stringForColumn:@"OCATD"]
                                        locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]]];
        }
        [_db close];

        townsHandler(towns);
    }];
}

- (void) loadStreetsOfTown:(Town *)town forBlock:(void (^)(NSArray<Street *> *))streetsHandler{
    [_dbOperationsQueue addOperationWithBlock:^{
        NSString *query = [NSString stringWithFormat:@"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"OCATD\" "
                           "FROM \"street_tbl\" "
                           "WHERE \"OCATD\" = %@", town.ocatd];
        NSMutableArray<Street *> *streets = [[NSMutableArray alloc] init];
        
        [_db open];
        FMResultSet *resultSet = [_db executeQuery:query];
        while([resultSet next]){
            [streets addObject:[[Street alloc] initWithId:[resultSet longForColumn:@"PKUID"]
                                                     name:[resultSet stringForColumn:@"NAME"]
                                                     code:[resultSet stringForColumn:@"CODE"]
                                                    ocatd:[resultSet stringForColumn:@"OCATD"]
                                             locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]]];
        }
        [_db close];
        
        streetsHandler(streets);
    }];
}

- (void) loadHousesOfStreet:(Street *)street forBlock:(void (^)(NSArray<House *> *))housesHandler{
    [_dbOperationsQueue addOperationWithBlock:^{
        NSString *query = [NSString stringWithFormat:@"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"OCATD\" "
                           "FROM \"doma_tbl\" "
                           "WHERE \"OCATD\" = %@", street.ocatd];
        NSMutableArray <House *> *houses = [[NSMutableArray alloc] init];
        
        [_db open];
        FMResultSet *resultSet = [_db executeQuery:query];
        while([resultSet next]){
            NSArray <NSString *> *housesNames = [[resultSet stringForColumn:@"name"] componentsSeparatedByString:@","];
            
            for (NSString *houseName in housesNames) {
                [houses addObject:[[House alloc] initWithId:[resultSet longForColumn:@"PKUID"]
                                                       name:houseName
                                                       code:[resultSet stringForColumn:@"CODE"]
                                                      ocatd:[resultSet stringForColumn:@"OCATD"]
                                               locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]]];
            }
            
        }
        [_db close];
        
        housesHandler(houses);
    }];
}

@end
