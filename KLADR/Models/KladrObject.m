//
//  Region.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrObject.h"
#import "KladrObject+Protected.h"



@implementation KladrObject{
    NSUInteger _pkuid;
    NSString *_name;
    NSString *_code;
    NSString *_ocatd;
    LocationType *_locationType;
    
    NSInteger _sortPriority;
    NSNumber *_regionCode;
    NSNumber *_taxServiceCode;
    NSNumber *_postIndex;
    
    KladrRelevanceCode _relevance;
}

@synthesize code = _code;
@synthesize ocatd = _ocatd;
@synthesize name = _name;
@synthesize pkuid = _pkuid;
@synthesize locationType = _locationType;
@synthesize taxServiceCode = _taxServiceCode;
@synthesize postIndex = _postIndex;
@synthesize relevance = _relevance;

- (instancetype)initWithId:(NSUInteger)pkuid
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
        
        [self parseOcatd:ocatd];
        [self parseCode:code];
    }
    return self;
}

- (void)parseOcatd:(NSString *)ocatd{
    //_regionCode = [NSNumber numberWithLong:[[ocatd substringWithRange:NSMakeRange(0, 2)] integerValue]];
}

@end

@implementation KladrObject(Protected)

- (void)parseCode:(NSString *)code{
    [self parseRelevanceStatusFromCode:code];
}

- (void)parseRelevanceStatusFromCode:(NSString *)code{
    NSUInteger relevanceCode = (NSUInteger) [[_code substringFromIndex:[_code length] - 2] integerValue];
    switch(relevanceCode) {
        case 0:
            _relevance = KladrRelevanceCodeRelevant;
            break;
        case 1 ... 50:
            _relevance = KladrRelevanceCodeOldName;
            break;
        case 51:
            _relevance = KladrRelevanceCodeReplaced;
            break;
        case 52 ... 98:
            _relevance = KladrRelevanceCodeRelevant;
            break;
        case 99:
            _relevance = KladrRelevanceCodeNotExists;
            break;
    }
}

@end
