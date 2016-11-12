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

- (void) indexKLADRObject:(KLADRObject *)kladrObject;

- (KLADRObject *) withName:(NSString *)name;
- (KLADRObject *) withCode:(NSString *)code;
- (NSArray<KLADRObject *> *) withLocationType:(LocationType *)locationType;

- (void) setSelectedByName:(NSString *)selectedName;
- (void) setSelected:(KLADRObject *)selected;
- (NSString *) selectedName;
- (KLADRObject *) selectedObject;


//- (NSArray<NSString *> *) names;
- (NSArray<KLADRObject *> *) searchWithName:(NSString *)string;
- (NSArray<KLADRObject *> *) objects;

- (KLADRObject *) withPkuid:(NSUInteger)pkuid;

@end
