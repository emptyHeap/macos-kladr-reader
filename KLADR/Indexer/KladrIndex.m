//
//  KLADRIndexator.m
//  KLADR
//
//  Created by Konstantin on 08/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrIndex.h"
#import "KladrObject.h"

@implementation KladrIndex{
    NSMutableDictionary <NSString *, KladrObject *> *_nameIndex, *_codeIndex;
    NSMutableDictionary <NSNumber *, KladrObject *> *_pkuidIndex;
    NSMutableDictionary <LocationType *, NSMutableArray<KladrObject *> *> *_locationTypeIndex;
    KladrObject *_selected;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        _nameIndex = [[NSMutableDictionary alloc] init];
        _codeIndex = [[NSMutableDictionary alloc] init];
        _pkuidIndex = [[NSMutableDictionary alloc] init];
        _locationTypeIndex = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addKladrObject:(KladrObject *)kladrObject{
    _pkuidIndex[[NSNumber numberWithUnsignedInteger:kladrObject.pkuid]] = kladrObject;
    _nameIndex[kladrObject.name] = kladrObject;
    _codeIndex[kladrObject.code] = kladrObject;
}

- (void) addKladrObjects:(NSArray<KladrObject *> *)kladrObjects{
    for (KladrObject *object in kladrObjects){
        [self addKladrObject:object];
    }
}

- (KladrObject *)withCode:(NSString *)code{
    return _codeIndex[code];
}

- (KladrObject *)withName:(NSString *)name{
    return _nameIndex[name];
}

- (KladrObject *)withPkuid:(NSUInteger)pkuid{
    return _pkuidIndex[[NSNumber numberWithUnsignedInteger:pkuid]];
}

- (NSArray<KladrObject *> *)withLocationType:(LocationType *)locationType{
    return _locationTypeIndex[locationType];
}

- (NSArray<NSString *> *)names{
    return [_nameIndex allKeys];
}

- (NSArray<KladrObject *> *)objects{
    return [_nameIndex allValues];
}

- (NSArray<NSString *> *) searchWithName:(NSString *)string{
    
    if ([string length] == 0){
        return self.objects;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(KladrObject *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
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
