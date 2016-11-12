//
//  Region.h
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationType.h"
#import "../Indexer/KLADRIndex.h"

@interface KLADRObject : NSObject

@property (readonly) NSUInteger pkuid;
@property (nonatomic, strong, readonly) NSString *name, *code, *ocatd;
@property (readonly) NSNumber *postIndex, *taxServiceCode, *regionCode;

@property (nonatomic, strong, readonly) LocationType *locationType;

//must be part of sortable implementation
@property (nonatomic) NSInteger sortPriority;

- (id) initWithId:(NSUInteger)pkuid
             name:(NSString *)name
             code:(NSString *)code
            ocatd:(NSString *)okatd
     locationType:(LocationType *)locationType;
- (void) parseOcatd;
- (void) select;

+ (void) cacheNewWithId:(NSUInteger)pkuid
                   name:(NSString *)name
                   code:(NSString *)code
                  ocatd:(NSString *)okatd
           locationType:(LocationType *)locationType;
+ (id) selected;
+ (id) withName:(NSString *)name;
+ (id) withCode:(NSString *)code;
+ (id) withPkuid:(NSUInteger)pkuid;

+ (NSArray <id> *) searchWithName:(NSString *)string;
+ (KLADRIndex *) index;
+ (void) renewIndex;


+ (void) clearMem;

@end

@protocol KLADRAbbreviations

+ (NSArray <NSString *> *)abbreviations;

@end