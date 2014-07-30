//
//  FirstViewController.m
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "FirstViewController.h"
#import "AccidentRegion.h"
#import "AccidentRegionDAO.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoThisCounty:(id)sender {
    AccidentRegionDAO *regions = [[AccidentRegionDAO alloc] init];
    [regions getAccidents: @"ALLENGENY" of:@"Pennsylvania"];
}

@end
