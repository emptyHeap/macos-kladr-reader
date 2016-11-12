//
//  Region.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KLADRObject.h"

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

@end

