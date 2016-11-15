//
//  District.m
//  KLADR
//
//  Created by Konstantin on 15/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "District.h"
#import "KladrObject+Protected.h"

@implementation District{
    NSUInteger _districtCode;
}

@synthesize districtCode;

- (void) parseCode:(NSString *)code{
    [super parseCode:code];
    _districtCode = (NSUInteger) [[code substringWithRange:DistrictCodeRange] integerValue];
}

@end
