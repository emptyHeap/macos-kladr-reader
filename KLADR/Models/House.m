//
//  House.m
//  KLADR
//
//  Created by Konstantin on 09/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "House.h"
#import "KladrObject+Protected.h"

@implementation House

+ (NSArray <NSString *> *) abbreviations{
    return @[@"д", @"д."];
}

- (instancetype)initWithId:(NSUInteger)pkuid
                      name:(NSString *)name
                      code:(NSString *)code
                     ocatd:(NSString *)ocatd
              locationType:(LocationType *)locationType{
    self = [super initWithId:pkuid
                        name:name
                        code:code
                       ocatd:ocatd
                locationType:locationType];
    if (self){
        for (LocationType *locationType in [LocationType allTypes]){
            NSRange abbreviationRange = [name rangeOfString:locationType.abbreviation];
            if (abbreviationRange.location == NSNotFound) {
                continue;
            }
            self.name = [name stringByReplacingCharactersInRange:abbreviationRange withString:@""];
        }
    }
    return self;
}


@end
