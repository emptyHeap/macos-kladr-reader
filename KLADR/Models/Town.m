//
//  Town.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "Town.h"

@implementation Town{
    NSNumber *_townCode;
}

+ (NSArray<NSString *> *)abbreviations{
    return @[@"г", @"г.", @"городок", @"д", @"ст-ца", @"аул", @"п", @"дп", @"г.ф.з."];
}

- (void) parseOcatd{
    [super parseOcatd];
    _townCode = [NSNumber numberWithLong:[[self.ocatd substringWithRange:NSMakeRange(8, 3)] integerValue]];
}

@end
