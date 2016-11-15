//
//  Street.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "Street.h"
#import "KladrObject+Protected.h"

@implementation Street{
    NSUInteger _streetCode;
}

@synthesize streetCode = _streetCode;

+ (NSArray <NSString *> *)abbreviations{
    return @[@"ул", @"ул."];
}

- (void) parseCode:(NSString *)code{
    [super parseCode:code];
    _streetCode = (NSUInteger) [[code substringWithRange:StreetCodeRange] integerValue];
}
//- (void) parseOcatd{
//    [super parseOcatd];
//}

@end
