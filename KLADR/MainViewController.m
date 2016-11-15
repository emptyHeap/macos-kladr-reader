//
//  MainViewController.m
//  Kladr
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "MainViewController.h"

#import "Models/KladrModels.h"
#import "AppDelegate.h"
#import "ORM/KladrORM.h"

@interface MainViewController ()

@end

@implementation MainViewController {
    
    KladrIndex *_regions, *_towns, *_streets, *_houses;
    NSArray <LocationType *> *_locations;
    
    Region *_selectedRegion;
    Town *_selectedTown;
    Street *_selectedStreet;
    House *_selectedHouse;
    
    KladrORM *_kladrDatabase;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _regions = [[KladrIndex alloc] init];
    _towns = [[KladrIndex alloc] init];
    _streets = [[KladrIndex alloc] init];
    _houses = [[KladrIndex alloc] init];
    
    AppDelegate *applicationDelegate = ((AppDelegate *)[[NSApplication sharedApplication] delegate]);
    _kladrDatabase = applicationDelegate.kladrDatabase;
    
    [_kladrDatabase loadLocationTypesForBlock:^(NSArray<LocationType *> *locations) {
        _locations = locations;
    }];
    [_kladrDatabase loadRegionsForBlock:^(NSArray<Region *> *regions) {
        [_regions addKladrObjects:regions];
    }];
}

- (NSArray<NSString *> *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray<NSString *> *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index{

    
    if (![_kladrDatabase operationsFinished]){
        [_kladrDatabase executeInMainQueueAfterOperationsBlock:^{
            [[control currentEditor] complete:control];
        }];
        
        //prevent autocomplete for now
        return nil;
    } else {
        NSArray<KladrObject *> *variants;
        NSString *query = [textView string];
        NSMutableArray <NSString *> *stringResult = [[NSMutableArray alloc] init];
        
        if (control == self.districtTextField)
            variants = [_regions searchWithName:query];
        else if (control == self.townTextField)
            variants = [_towns searchWithName:query];
        else if (control == self.streetTextField)
            variants = [_streets searchWithName:query];
        else if (control == self.houseTextField)
            variants = [_houses searchWithName:query];
        for (KladrObject *variant in variants) {
            [stringResult addObject:variant.name];
        }
        
        return stringResult;
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{

    NSString *query = [obj.object stringValue];
    NSTextField *control = obj.object;
    
    if (query != nil || [query isEqualToString:@""]){
    
        if (control == self.districtTextField){
            _selectedRegion = [_regions withName:control.stringValue];
            [_kladrDatabase loadTownsOfRegion:_selectedRegion forBlock:^(NSArray<Town *> *loadedTowns) {
                _towns = [[KladrIndex alloc] init];
                [_towns addKladrObjects:loadedTowns];
            }];
        } else if (control == self.townTextField) {
            _selectedTown = [_towns withName:control.stringValue];
            [_kladrDatabase loadStreetsOfTown:_selectedTown forBlock:^(NSArray<Street *> *loadedStreets) {
                _streets = [[KladrIndex alloc] init];
                [_streets addKladrObjects:loadedStreets];
            }];
        } else if (control == self.streetTextField) {
            _selectedStreet = [_streets withName:control.stringValue];
            [_kladrDatabase loadHousesOfStreet:_selectedStreet forBlock:^(NSArray<House *> *loadedHouses) {
                _houses = [[KladrIndex alloc] init];
                [_houses addKladrObjects:loadedHouses];
            }];
        } else if (control == self.houseTextField) {
            // for what all that mess?
        }
        
    }
    
//    if (control == self.districtTextField){
//        [self clearSubs:self.townTextField];
//    } else if (control == self.townTextField) {
//        [self clearSubs:self.streetTextField];
//    } else if (control == self.streetTextField) {
//         [self clearSubs:self.houseTextField];
//    } else if (control == self.houseTextField) {
//         // no subs
//    }

}

- (void) clearSubs:(NSTextField *)textField {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        textField.stringValue = @"";
        [self controlTextDidEndEditing:[NSNotification notificationWithName:@"" object:textField]];
    }];
}

@end
