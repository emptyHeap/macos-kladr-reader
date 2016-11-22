//
//  CustomORM.m
//  KLADR
//
//  Created by Konstantin on 12/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrORM.h"
#import "FMDB/FMDatabase.h"

static NSUInteger const KladrORMCodeFieldLength = 13;

@implementation KladrORM{
    FMDatabase *_db;
    NSOperationQueue *_dbOperationsQueue;
    NSUInteger _nonDbOperations;
}

- (id) initWithPath:(NSString *)path{
    self = [super init];
    if (self){
        _nonDbOperations = 0;
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
                                                     abbreviation:[resultSet stringForColumn:@"SCNAME"]
                                                         fullName:[resultSet stringForColumn:@"SOCRNAME"]
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
        "WHERE \"CODE\" \% 100000000000 = 0";
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

- (NSString *) repeatString:(NSString *)string times:(NSUInteger)times{
    NSMutableString *generatedString = [[NSMutableString alloc] initWithCapacity:times * [string length]];
    for (NSUInteger i = 0; i < times; i++){
        [generatedString appendString:string];
    }
    return generatedString;
}

- (NSString *) selectorStringForElementsWithParentCode:(NSUInteger)parentCode inRange:(NSRange)parentRange{
    NSString *field = @"\"CODE\"";
    NSString *parentCup = [NSString stringWithFormat:@"1%@", [self repeatString:@"0" times:parentRange.length]];
    NSString *parentFloor = [NSString stringWithFormat:@"1%@", [self repeatString:@"0" times:parentRange.location]];
    NSString *notAParentObject = [NSString stringWithFormat:@"%@ %% %@ != 0", field, parentFloor];
    
    return [NSString stringWithFormat:@"(%@ / %@) %% %@ == %lu AND %@", field, parentFloor, parentCup, parentCode, notAParentObject];
}

- (NSString *) selectorStringForElementsWithParentCode:(NSUInteger)parentCode withParendRange:(NSRange)parentRange withSubclassCodeLength:(NSRange)childrenRange {
    NSString *childrenFloor = [NSString stringWithFormat:@"1%@", [self repeatString:@"0" times:childrenRange.location]];
    NSString *childrenCup = [NSString stringWithFormat:@"1%@", [self repeatString:@"0" times:childrenRange.location + childrenRange.length]];
    
    NSString *field = @"\"CODE\"";
    
    NSString *notLocalObject = [NSString stringWithFormat:@"%@ %% %@ == 0", field, childrenFloor];
    NSString *isChildOfParent = [self selectorStringForElementsWithParentCode:parentCode inRange:parentRange];
    return [NSString stringWithFormat:@"%@ AND %@ ", notLocalObject, isChildOfParent];
}

- (void) loadTownsOfRegion:(Region *)region forBlock:(void (^)(NSArray<Town *> *))townsHandler{
    [_dbOperationsQueue addOperationWithBlock:^{
        NSString *query = [NSString stringWithFormat:@"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"INDEX\", \"GNINMB\", \"OCATD\" "
                           @"FROM \"kladr_tbl\" "
                           @"WHERE %@", [self selectorStringForElementsWithParentCode:region.regionCode
                                                                      withParendRange:NSMakeRange(11, 2)
                                                               withSubclassCodeLength:NSMakeRange(5, 6)]];
                           //@"WHERE \"CODE\" %% 100000000000 != 0 AND \"CODE\" / 100000000000 = %lu", region.regionCode];
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
//                           "WHERE %@ AND %@",
//                           [self selectorStringForElementsWithParentCode:town.regionCode
//                                                                 inRange:NSMakeRange(11 + 4, 2)],
//                           [self selectorStringForElementsWithParentCode:town.townCode
//                                                                     withParendRange:NSMakeRange(5 + 4, 6)
//                                                              withSubclassCodeLength:NSMakeRange(2, 7)]];
                           "WHERE \"CODE\" LIKE \"%@%%\"", [town.code substringToIndex:10]];
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
//                           "WHERE %@ AND %@ AND %@",
//                           [self selectorStringForElementsWithParentCode:street.streetCode
//                                                                 inRange:NSMakeRange(2 + 2, 7)],
//                           [self selectorStringForElementsWithParentCode:street.regionCode
//                                                                 inRange:NSMakeRange(11 + 4 + 2, 2)],
//                           [self selectorStringForElementsWithParentCode:street.townCode
//                                                                 inRange:NSMakeRange(5 + 4 + 2, 6)]];
                           "WHERE \"CODE\" LIKE \"%@%%\"", [street.code substringToIndex:14]];
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

- (BOOL) operationsFinished{
    return (([_dbOperationsQueue operationCount] - _nonDbOperations) == 0);
}

- (void) executeInMainQueueAfterOperationsBlock:(void (^)(void))block{
    [_dbOperationsQueue addOperationWithBlock:^{
        _nonDbOperations --;
        [[NSOperationQueue mainQueue] addOperationWithBlock:block];
    }];
    _nonDbOperations ++;
}

@end
