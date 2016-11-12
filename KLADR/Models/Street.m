//
//  Street.m
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "Street.h"

@implementation Street{
    NSNumber *_streetCode;
}

+ (NSArray <NSString *> *)abbreviations{
    return @[@"ул", @"ул."];
}

- (void) parseOcatd{
    [super parseOcatd];
}

@end
