//
//  LocationTypeAbbreviation.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "LocationType.h"

#define LEVELS 6

static NSMutableDictionary <NSString *, LocationType *> *AbbreviationIndex, *FullNameIndex, *CodeIndex;
static NSMutableDictionary <NSNumber *, LocationType *> *PkuidIndex;
static NSArray <NSMutableArray <LocationType *> *> *LevelIndex;

@implementation LocationType{
    NSString *_abbreviation, *_fullName, *_code;
    NSUInteger _pkuid, _level;
}

+ (NSArray *)regionTypesAbbreviations {
    return @[@"АО", @"Аобл", @"Респ", @"Чувашия", @"а.обл.", @"о.окр", @"г.ф.з", @"обл", @"обл.", @"округ", @"респ.", @"АО"];
  //@[@"Автономный округ", @"Автономная область", @"Республика", @"Чувашия", @"Автономная область", @"Автономный округ", @"Город федерального значения", @"Область", @"Округ", @"Республика", @"Автономный округ"];
}

+ (NSArray *)townTypesAbbreviations {
    return @[@"г", @"г.", @"городок", @"д", @"ст-ца", @"аул", @"п", @"дп", @"г.ф.з."];
    //return @[@"Город", @"Деревня", @"Станица", @"Аул", @"Поселок", @"Дачный поселок", @"Город федерального значения"];
}

+ (void) initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AbbreviationIndex = [[NSMutableDictionary alloc] init];
        FullNameIndex = [[NSMutableDictionary alloc] init];
        CodeIndex = [[NSMutableDictionary alloc] init];
        PkuidIndex = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *mLevelIndex = [NSMutableArray arrayWithCapacity:LEVELS];
        for (int i; i < LEVELS; i++){
            [mLevelIndex addObject:[NSMutableArray array]];
        }
        LevelIndex = [[NSArray alloc] initWithArray:mLevelIndex];
    });
}

- (id) initWithId:(NSUInteger)pkuid
     abbreviation:(NSString *)abbreviation
         fullName:(NSString *)fullName
            level:(NSUInteger)level
             code:(NSString *)code{
    self = [super init];
    if (self) {
        _pkuid = pkuid;
        _abbreviation = abbreviation;
        _fullName = fullName;
        _level = level;
        _code = code;
        
        AbbreviationIndex[_abbreviation] = self;
        FullNameIndex[_fullName] = self;
        CodeIndex[_code] = self;
        PkuidIndex[[NSNumber numberWithUnsignedInteger:_pkuid]] = self;
    }
    return self;
}

- (void) dealloc{
}

+ (id) withAbbreviation:(NSString *)abbreviation{
    return AbbreviationIndex[abbreviation];
}

+ (id) withFullName:(NSString *)fullName{
    return FullNameIndex[fullName];
}

+ (id) withCode:(NSString *)code{
    return CodeIndex[code];
}

+ (id) withPkuid:(NSUInteger)pkuid{
    return PkuidIndex[[NSNumber numberWithUnsignedInteger:pkuid]];
}

+ (NSArray <LocationType *> *) typesWithLevel:(NSUInteger)level{
    return LevelIndex[level];
}

+ (NSArray<LocationType *> *)allTypes{
    return [AbbreviationIndex allValues];
}

@end

