//
//  CustomXibView.m
//  KLADR
//
//  Created by Konstantin on 16/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "CustomXibView.h"

@implementation CustomXibView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadXibData];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self loadXibData];
    }
    return self;
}

- (void)loadXibData {
    NSView *view = nil;
    NSArray *nibObjects;
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self topLevelObjects:&nibObjects];
    for (id nibObject in nibObjects){
        if ([nibObject isKindOfClass:[NSView class]]){
            view = nibObject;
            break;
        }
    }
    
    if (view != nil) {
        _containerView = view;
        //view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints:YES];
    }
}

@end
