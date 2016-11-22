//
//  CustomXibView.h
//  KLADR
//
//  Created by Konstantin on 16/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomXibView : NSView

@property (strong, nonatomic) NSView *containerView;
@property (strong, nonatomic) NSArray *customConstraints;

@end
