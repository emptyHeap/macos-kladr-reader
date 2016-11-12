//
//  House.m
//  KLADR
//
//  Created by Konstantin on 09/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "House.h"

@implementation House

+ (NSArray <NSString *> *) abbreviations{
    return @[@"д", @"д."];
}

- (void) parseOcatd{
    [super parseOcatd];
}

+ (void)cacheNewWithId:(NSUInteger)pkuid
                  name:(NSString *)name
                  code:(NSString *)code
                 ocatd:(NSString *)ocatd
          locationType:(LocationType *)locationType{
    NSArray <NSString *> *houses = [name componentsSeparatedByString:@","];
    for (NSString *house in houses){
        KLADRObject *newObject = [[self alloc] initWithId:pkuid
                                                     name:house
                                                     code:code
                                                    ocatd:ocatd
                                             locationType:locationType];
        [[self  index] indexKLADRObject:newObject];
    }
    
}


@end
