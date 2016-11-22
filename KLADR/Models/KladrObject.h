//
//  Region.h
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationType.h"
#import "../Indexer/KladrIndex.h"

typedef NS_ENUM(NSUInteger, KladrRelevanceCode){
    KladrRelevanceCodeRelevant,
    KladrRelevanceCodeOldName,
    KladrRelevanceCodeReplaced,
    KladrRelevanceCodeNotExists
};

@interface KladrObject : NSObject

@property (readonly) NSUInteger pkuid;
@property (nonatomic, strong, readonly) NSString *name, *code, *ocatd, *fullName;
@property (readonly) NSNumber *postIndex, *taxServiceCode;
@property (readonly) KladrRelevanceCode relevance;

@property (nonatomic, strong, readonly) LocationType *locationType;

//must be part of sortable implementation
@property (nonatomic) NSInteger sortPriority;

- (instancetype) initWithId:(NSUInteger)pkuid
             name:(NSString *)name
             code:(NSString *)code
            ocatd:(NSString *)okatd
     locationType:(LocationType *)locationType;

- (NSString *) getHumanReadableName;

@end

@protocol KladrAbbreviations

+ (NSArray <NSString *> *)abbreviations;

@end
