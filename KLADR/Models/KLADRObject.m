//
//  Region.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KLADRObject.h"
#import "DataHandler.h"

@implementation KLADRObject{
    NSUInteger _pkuid;
    NSString *_name;
    NSString *_code;
    NSString *_ocatd;
    LocationType *_locationType;
    
    NSInteger _sortPriority;
    NSNumber *_regionCode;
    NSNumber *_taxServiceCode;
    NSNumber *_postIndex;
}

@synthesize code = _code;
@synthesize ocatd = _ocatd;
@synthesize name = _name;
@synthesize pkuid = _pkuid;
@synthesize locationType = _locationType;
@synthesize regionCode = _regionCode;
@synthesize taxServiceCode = _taxServiceCode;
@synthesize postIndex = _postIndex;

- (id)initWithId:(NSUInteger)pkuid
            name:(NSString *)name
            code:(NSString *)code
           ocatd:(NSString *)ocatd
    locationType:(LocationType *)locationType{
    self = [super init];
    if (self){
        _code = code;
        _ocatd = ocatd;
        _pkuid = pkuid;
        _name = name;
        _locationType = locationType;
        _sortPriority = -1;
        
        [self parseOcatd];
    }
    return self;
}

- (void)parseOcatd{
    _regionCode = [NSNumber numberWithLong:[[_ocatd substringWithRange:NSMakeRange(0, 2)] integerValue]];
}

- (void)select{
    
}

+ (void)cacheNewWithId:(NSUInteger)pkuid
                  name:(NSString *)name
                  code:(NSString *)code
                 ocatd:(NSString *)ocatd
          locationType:(LocationType *)locationType{
    
    KLADRObject *newObject = [[self alloc] initWithId:pkuid
                                                 name:name
                                                 code:code
                                                ocatd:ocatd
                                         locationType:locationType];
    [[self  index] addKLADRObject:newObject];
}

+ (KLADRObject *)withCode:(NSString *)code{
    return [[self index] withCode:code];
}

+ (id)withName:(NSString *)name{
    return [[self index] withName:name];
}

+ (KLADRObject *)withPkuid:(NSUInteger)pkuid{
    return [[self index] withPkuid:pkuid];
}

+ (NSArray<KLADRObject *> *)withLocationType:(LocationType *)locationType{
    return [[self index] withLocationType: locationType];
}

+ (NSArray<KLADRObject *> *)searchWithName:(NSString *)string{
    return [[self index] searchWithName:string];
}

static NSMutableDictionary *gmainIndex;
static NSMutableDictionary <Class, KLADRIndex *> *mainIndex(){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gmainIndex = [[NSMutableDictionary alloc] init];
    });
    return gmainIndex;
};

+ (KLADRIndex *) index {
    return [mainIndex() objectForKey:[self class]];
}

+ (void) renewIndex {
    NSMutableDictionary <Class, KLADRIndex *> *cachedMainIndex = mainIndex();
    [cachedMainIndex removeObjectForKey:[self class]];
    KLADRIndex *newIndex = [[KLADRIndex alloc] init];
    [cachedMainIndex setObject:newIndex forKey:(id<NSCopying>)[self class]];
};

+ (void) initialize {
    [self renewIndex];
}

+ (void) clearMem {
    gmainIndex = nil;
}

@end

