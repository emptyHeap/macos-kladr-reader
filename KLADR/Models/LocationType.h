//
//  LocationTypeAbbreviation.h
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationType : NSObject

@property (readonly) NSUInteger pkuid, level;
@property (strong, readonly) NSString *abbreviation, *fullName;

+ (NSArray <NSString *> *)regionTypesAbbreviations;
+ (NSArray <NSString *> *)townTypesAbbreviations;

- (id) initWithId:(NSUInteger)pkuid
     abbreviation:(NSString *)abbreviation
         fullName:(NSString *)fullName
            level:(NSUInteger)level
             code:(NSString *)code;

+ (id) withAbbreviation:(NSString *)abbreviation;
+ (id) withFullName:(NSString *)fullName;
+ (id) withCode:(NSString *)code;
+ (id) withPkuid:(NSUInteger)pkuid;
+ (NSArray <LocationType *> *) typesWithLevel:(NSUInteger)level;
+ (NSArray <LocationType *> *) allTypes;

@end
