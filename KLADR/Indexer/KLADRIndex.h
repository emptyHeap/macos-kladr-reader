//
//  KLADRIndexator.h
//  KLADR
//
//  Created by Konstantin on 08/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KLADRObject;
@class LocationType;

@interface KLADRIndex : NSObject

- (void) addKLADRObject:(KLADRObject *)kladrObject;
- (void) addKLADRObjects:(NSArray <KLADRObject *> *)kladrObjects;

- (id) withName:(NSString *)name;
- (id) withCode:(NSString *)code;
- (NSArray<id> *) withLocationType:(LocationType *)locationType;

- (void) setSelectedByName:(NSString *)selectedName;
- (void) setSelected:(KLADRObject *)selected;

//- (NSArray<NSString *> *) names;
- (NSArray<id> *) searchWithName:(NSString *)string;
- (NSArray<id> *) objects;

- (KLADRObject *) withPkuid:(NSUInteger)pkuid;

@end
