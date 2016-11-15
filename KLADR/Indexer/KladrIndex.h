//
//  KladrIndexator.h
//  Kladr
//
//  Created by Konstantin on 08/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KladrObject;
@class LocationType;

@interface KladrIndex : NSObject

- (void) addKladrObject:(KladrObject *)kladrObject;
- (void) addKladrObjects:(NSArray <KladrObject *> *)kladrObjects;

- (id) withName:(NSString *)name;
- (id) withCode:(NSString *)code;
- (NSArray<id> *) withLocationType:(LocationType *)locationType;

//- (NSArray<NSString *> *) names;
- (NSArray<id> *) searchWithName:(NSString *)string;
- (NSArray<id> *) objects;

- (KladrObject *) withPkuid:(NSUInteger)pkuid;

@end
