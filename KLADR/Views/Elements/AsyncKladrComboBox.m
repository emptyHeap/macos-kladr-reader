//
//  AsyncComboBox.m
//  KLADR
//
//  Created by Konstantin on 22/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "AsyncKladrComboBox.h"

@implementation AsyncKladrComboBox {
    NSArray <KladrObject *> *_variants;
    NSArray <KladrObject *> *_filtered;
    KladrObject *_selected;
}
# pragma mark - Initialization

@synthesize parentChangedBlock;

- (void)setup {
    //self.completes = NO;
    self.usesDataSource = YES;
    self.dataSource = self;
    self.delegate = self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

# pragma mark - User actions
# pragma mark text changes controls

- (void)controlTextDidChange:(NSNotification *)obj {
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(KladrObject *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        evaluatedObject.sortPriority = [evaluatedObject.name rangeOfString:self.stringValue].location;
        if ( evaluatedObject.sortPriority == NSNotFound ){
            return NO;
        } else {
            return YES;
        }
    }];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *positionSort = [[NSSortDescriptor alloc] initWithKey:@"sortPriority" ascending:YES];
    NSArray *sortSequence = @[positionSort, nameSort];
    
    _filtered = [_variants filteredArrayUsingPredicate:predicate];
    _filtered = [_filtered sortedArrayUsingDescriptors:sortSequence];
    
    [[self cell] setAccessibilityExpanded: YES];
}

- (NSArray<NSString *> *)control:(NSControl *)control
                        textView:(NSTextView *)textView
                     completions:(NSArray<NSString *> *)words
             forPartialWordRange:(NSRange)charRange
             indexOfSelectedItem:(NSInteger *)index {
    //user readable variants must be returned
    [self.cell setAccessibilityExpanded:YES];
    return nil;
};

# pragma mark combo box changes controls

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    _selected = [_filtered objectAtIndex:[self indexOfSelectedItem]];
    if (_child) {
        _child.parentChangedBlock(_selected);
    }
    //invoke child reload data here
}

# pragma mark - data source

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    return _filtered.count;
}

- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    return [[_filtered objectAtIndex:index] getHumanReadableName];
}

- (void)updateWithData:(NSArray<KladrObject *> *)data {
    _variants = data;
    _filtered = _variants;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self reloadData];
    }];
}

# pragma mark - parent to child interaction

//- (void) loadDataFor:(KladrObject *)kladrObject {
//    [self updateWithData:self.dataGetterBlock(kladrObject)];
//}

@end
