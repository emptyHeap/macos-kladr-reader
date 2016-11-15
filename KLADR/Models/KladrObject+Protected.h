//
//  KladrObject+Protected.h
//  KLADR
//
//  Created by Konstantin on 15/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrObject.h"

@interface KladrObject (Protected)

- (void) parseCode:(NSString *)code;
- (void) parseOdatd:(NSString *)ocatd;

@end
