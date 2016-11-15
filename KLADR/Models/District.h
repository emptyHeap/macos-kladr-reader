//
//  District.h
//  KLADR
//
//  Created by Konstantin on 15/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"

static NSRange const DistrictCodeRange = {2, 3};

@interface District : Region

@property (readonly) NSInteger districtCode;

@end
