//
//  Region.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "Region.h"
#import "KladrObject+Protected.h"

@implementation Region{
    NSUInteger _regionCode;
}

@synthesize regionCode = _regionCode;

- (void) parseCode:(NSString *)code{
    [super parseCode:code];
    _regionCode = (NSUInteger) [[code substringWithRange:RegionRegionCodeRange] integerValue];
}

+ (NSArray <NSString *> *) abbreviations{
    return @[@"АО", @"Аобл", @"Респ", @"Чувашия", @"а.обл.", @"о.окр", @"г.ф.з", @"обл", @"обл.", @"округ", @"респ.", @"АО"];
}

@end
