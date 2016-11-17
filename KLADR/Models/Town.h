//
//  Town.h
//  KLADR
//
//  Created by Konstantin on 03/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "District.h"

static NSRange const TownCodeRange = {2, 6};

@interface Town : District <KladrAbbreviations>

@property (readonly) NSUInteger townCode;

@end
