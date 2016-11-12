//
//  MainViewController.m
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "MainViewController.h"
#import "KLADRModels.h"
#import "AppDelegate.h"
#import "DataHandler.h"
#import "ORM/KladrORM.h"

@interface MainViewController ()

@end

@implementation MainViewController {
    NSArray <LocationType *> *_locations;
    NSDictionary <NSString *, Region *> *_regions;
    NSDictionary <NSString *, Town *> *_towns;
    NSDictionary <NSString *, Street *> *_streets;
    NSDictionary <NSString *, House *> *_houses;
    KladrORM *_kladrDatabase;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *applicationDelegate = ((AppDelegate *)[[NSApplication sharedApplication] delegate]);
    _kladrDatabase = applicationDelegate.kladrDatabase;
    
    [_kladrDatabase loadLocationTypesForBlock:^(NSArray<LocationType *> *locations) {
        _locations = locations;
    }];
    
    [_kladrDatabase loadRegionsForBlock:^(NSArray<Region *> *regions) {
        NSMutableDictionary <NSString *, Region *> *regionsNameDict = [[NSMutableDictionary alloc] init];
        for (Region *region in regions){
            [regionsNameDict setObject:region forKey:region.name];
        }
        _regions = regionsNameDict;
    }];
}

- (NSArray<NSString *> *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray<NSString *> *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index{

    
    if ([[DataHandler dbOperationsQueue] operationCount] > 0){
        [[DataHandler dbOperationsQueue] addOperationWithBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[control currentEditor] complete:control];
            }];
        }];
        return nil;
    } else {
        NSArray<KLADRObject *> *variants;
        NSString *query = [textView string];
        NSMutableArray <NSString *> *stringResult = [[NSMutableArray alloc] init];
        
        if (control == self.districtTextField)
            variants = [Region searchWithName:query];
        else if (control == self.townTextField)
            variants = [Town searchWithName:query];
        else if (control == self.streetTextField)
            variants = [Street searchWithName:query];
        else if (control == self.houseTextField)
            variants = [House searchWithName:query];
        for (KLADRObject *variant in variants) {
            [stringResult addObject:variant.name];
        }
        
        return stringResult;
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{

    NSString *query = [obj.object stringValue];
    if (query != nil && ![query isEqualToString:@""]){
    
        NSTextField *control = obj.object;
        if (control == self.districtTextField){
            [DataHandler loadTownsForRegion:[Region withName:query]];
        } else if (control == self.townTextField) {
            [DataHandler loadStreetsForTown:[Town withName:query]];
        } else if (control == self.streetTextField) {
            [DataHandler loadHousesForStreet:[Street withName:query]];
        } else if (control == self.houseTextField) {
            // for what all that mess?
        }
    }
    
}

@end
