//
//  Street.h
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "Town.h"

static NSRange const StreetCodeRange = {11, 4};

@interface Street : Town <KladrAbbreviations>

@property (readonly) NSUInteger streetCode;

@end
