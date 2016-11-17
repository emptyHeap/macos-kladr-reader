//
//  Region.h
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KladrObject.h"

static NSRange const RegionCodeRange = {0, 2};

@interface Region : KladrObject <KladrAbbreviations>

@property (readonly) NSUInteger regionCode;

@end
