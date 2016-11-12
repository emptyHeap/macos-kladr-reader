//
//  KLADRIndexator.m
//  KLADR
//
//  Created by Konstantin on 08/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KLADRIndex.h"
#import "KLADRObject.h"

@implementation KLADRIndex{
    NSMutableDictionary <NSString *, KLADRObject *> *_nameIndex, *_codeIndex;
    NSMutableDictionary <NSNumber *, KLADRObject *> *_pkuidIndex;
    NSMutableDictionary <LocationType *, NSMutableArray<KLADRObject *> *> *_locationTypeIndex;
    KLADRObject *_selected;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        _nameIndex = [[NSMutableDictionary alloc] init];
        _codeIndex = [[NSMutableDictionary alloc] init];
        _pkuidIndex = [[NSMutableDictionary alloc] init];
        _locationTypeIndex = [[NSMutableDictionary alloc] init];
    }
    NSLog(@"%@ alloc", self);
    return self;
}

- (void) addKLADRObject:(KLADRObject *)kladrObject{
    _pkuidIndex[[NSNumber numberWithUnsignedInteger:kladrObject.pkuid]] = kladrObject;
    _nameIndex[kladrObject.name] = kladrObject;
    _codeIndex[kladrObject.code] = kladrObject;
}

- (void) addKLADRObjects:(NSArray<KLADRObject *> *)kladrObjects{
    for (KLADRObject *object in kladrObjects){
        [self addKLADRObject:object];
    }
}

- (KLADRObject *)withCode:(NSString *)code{
    return _codeIndex[code];
}

- (KLADRObject *)withName:(NSString *)name{
    return _nameIndex[name];
}

- (KLADRObject *)withPkuid:(NSUInteger)pkuid{
    return _pkuidIndex[[NSNumber numberWithUnsignedInteger:pkuid]];
}

- (NSArray<KLADRObject *> *)withLocationType:(LocationType *)locationType{
    return _locationTypeIndex[locationType];
}

- (NSArray<NSString *> *)names{
    return [_nameIndex allKeys];
}

- (NSArray<KLADRObject *> *)objects{
    return [_nameIndex allValues];
}

- (NSArray<NSString *> *) searchWithName:(NSString *)string{
    
    if ([string length] == 0){
        return self.objects;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(KLADRObject *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        evaluatedObject.sortPriority = [evaluatedObject.name rangeOfString:string].location;
        
        if ( evaluatedObject.sortPriority == NSNotFound ){
            return NO;
        } else {
            return YES;
        }
    }];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *positionSort = [[NSSortDescriptor alloc] initWithKey:@"sortPriority" ascending:YES];
    NSArray *sortSequence = @[positionSort, nameSort];
    
    NSArray *result = [[self objects] filteredArrayUsingPredicate:predicate];
    result = [result sortedArrayUsingDescriptors:sortSequence];
    
    return result;
}


@end
