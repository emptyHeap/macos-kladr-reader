//
//  DataHandler.m
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "DataHandler.h"

#define DB_PATH @"/Users/heap/Documents/kladr.sqlite"

@implementation DataHandler

+ (NSOperationQueue *) dbOperationsQueue{
    static NSOperationQueue *dbOperationsQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbOperationsQueue = [[NSOperationQueue alloc] init];
        [dbOperationsQueue setMaxConcurrentOperationCount:1];
    });
    return dbOperationsQueue;
}

+ (void)preload {
    [[self dbOperationsQueue] addOperationWithBlock:^{
        [DataHandler loadLocations];
        [DataHandler loadRegions];
    }];
}

+ (FMDatabase *) db{
    static FMDatabase *_db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"kladr" ofType:@"sqlite"];
        _db = [FMDatabase databaseWithPath: path];
        _db.traceExecution = YES;
    });
    
    return _db;
}

#pragma mark
#pragma mark SQL

#pragma mark helpers

+ (NSString *) sanitizePlaceholderFor:(NSUInteger)elements{
    NSMutableString *questionMarks = [NSMutableString string];
    [questionMarks appendString:@"?"];
    for (int i = 1; i < elements; i++){
        [questionMarks appendString: @",?"];
    }
    return questionMarks;
}

#pragma mark SQL wrappers

+ (void) loadLocations{    
    FMDatabase *db = [DataHandler db];

    db.traceExecution = YES;
    [db open];
    NSString *query =   @"SELECT \"PKUID\", \"SOCRNAME\", \"SCNAME\", \"LEVEL\", \"KOD_T_ST\" "
                            "FROM \"socrbase_tbl\"";
    FMResultSet *resultSet = [db executeQuery:query];
    NSMutableArray *locations = [NSMutableArray array];
    while([resultSet next]){
        [locations addObject:[[LocationType alloc] initWithId:[resultSet longForColumn:@"PKUID"]
                            abbreviation:[resultSet stringForColumn:@"SOCRNAME"]
                                fullName:[resultSet stringForColumn:@"SCNAME"]
                                   level:[resultSet longForColumn:@"LEVEL"]
                                    code:[resultSet stringForColumn:@"KOD_T_ST"]]];
    }
    NSLog(@"%d, %@", [db lastErrorCode], [db lastErrorMessage]);
    [db close];
}

+ (void) getFromKLADRByAbbreviations:(NSArray <NSString *> *)abbreviations withClass:(Class)class {
    FMDatabase *db = [DataHandler db];

    [db open];
    NSString *query = @"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"INDEX\", \"GNINMB\", \"OCATD\" "
    "FROM \"kladr_tbl\" "
    "WHERE \"OCATD\" != \"\" AND \"OCATD\" \% 1000000000 = 0";
    FMResultSet *resultSet = [db executeQuery:query withArgumentsInArray:abbreviations];
    
    while([resultSet next]){
        [class cacheNewWithId:[resultSet longForColumn:@"PKUID"]
                         name:[resultSet stringForColumn:@"NAME"]
                         code:[resultSet stringForColumn:@"CODE"]
                        ocatd:[resultSet stringForColumn:@"OCATD"]
                 locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]];
    }
    [db close];
}

+ (void) loadRegions {
    [[DataHandler dbOperationsQueue] addOperationWithBlock:^{
        [self getFromKLADRByAbbreviations:[Region abbreviations] withClass: [Region class]];
    }];
}

+ (void) loadTownsForRegion:(Region *)region {
    [[DataHandler dbOperationsQueue] addOperationWithBlock:^{
        FMDatabase *db = [DataHandler db];
        NSString *query = [NSString stringWithFormat:@"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"INDEX\", \"GNINMB\", \"OCATD\" "
                           @"FROM \"kladr_tbl\" "
                           @"WHERE \"OCATD\" %% 1000000000 != 0 AND \"OCATD\" / 1000000000 = %@", region.regionCode];
        NSLog(@"open");
        [db open];
        FMResultSet *resultSet = [db executeQuery:query];
        while([resultSet next]){
            [Town cacheNewWithId:[resultSet longForColumn:@"PKUID"]
                            name:[resultSet stringForColumn:@"NAME"]
                            code:[resultSet stringForColumn:@"CODE"]
                           ocatd:[resultSet stringForColumn:@"OCATD"]
                    locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]];
        }
        [db close];
        NSLog(@"close");
    }];
}

+ (void) loadStreetsForTown:(Town *)town {
    [[DataHandler dbOperationsQueue] addOperationWithBlock:^{
        FMDatabase *db = [DataHandler db];
        NSString *query = [NSString stringWithFormat:@"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"OCATD\" "
                           "FROM \"street_tbl\" "
                           "WHERE \"OCATD\" = %@", town.ocatd];
        NSLog(@"open s");
        [db open];
        FMResultSet *resultSet = [db executeQuery:query];
        while([resultSet next]){
            [Street cacheNewWithId:[resultSet longForColumn:@"PKUID"]
                              name:[resultSet stringForColumn:@"NAME"]
                              code:[resultSet stringForColumn:@"CODE"]
                             ocatd:[resultSet stringForColumn:@"OCATD"]
                      locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]];
        }
        [db close];
        NSLog(@"close");
    }];
}

+ (void) loadHousesForStreet:(Street *)street {
    [[DataHandler dbOperationsQueue] addOperationWithBlock:^{
        FMDatabase *db = [DataHandler db];
        NSString *query = [NSString stringWithFormat:@"SELECT \"PKUID\", \"NAME\", \"SOCR\", \"CODE\", \"OCATD\" "
                           "FROM \"doma_tbl\" "
                           "WHERE \"OCATD\" = %@", street.ocatd];
        NSLog(@"open s");
        [db open];
        FMResultSet *resultSet = [db executeQuery:query];
        while([resultSet next]){
            [House cacheNewWithId:[resultSet longForColumn:@"PKUID"]
                             name:[resultSet stringForColumn:@"NAME"]
                             code:[resultSet stringForColumn:@"CODE"]
                            ocatd:[resultSet stringForColumn:@"OCATD"]
                     locationType:[LocationType withAbbreviation:[resultSet stringForColumn:@"SOCR"]]];
        }
        [db close];
        NSLog(@"close");
    }];
}

@end
