//
//  HistoryViewController.m
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import "HistoryViewController.h"
#import "ViolationDAO.h"
#import "Violation.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGest)];
    [_swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:_swipeLeft];
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGest)];
    [_swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:_swipeRight];
}

- (void) viewDidAppear:(BOOL)animated {
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *violations = [[NSMutableArray alloc] init];
    ViolationDAO *violateData = [[ViolationDAO alloc] init];
    violations = [violateData getViolations];
    
    self.violations = [[NSMutableArray alloc] init];
    self.dates = [[NSMutableArray alloc] init];
    
    for (Violation *vio in violations) {
        [self.dates addObject:vio.dateOfViolation];
        [self.violations addObject:[NSString stringWithFormat:@"%d", vio.count]];
    }
    [self.Table reloadData];
    NSLog(@"Done fetching records");
}

-(void) swipeRightGest {
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex - 1];
}

-(void) swipeLeftGest {
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"List Of Violations";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dates count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:SimpleIdentifier];
    }

    cell.textLabel.text = self.dates[indexPath.row];
    cell.detailTextLabel.text = self.violations[indexPath.row];

    
//    if (indexPath.row == 5)
//    {
//    UISwitch *switch1 = [[UISwitch alloc]initWithFrame:CGRectMake(100, 0, 100, 100)];
//    [cell addSubview:switch1];
//    }
    
    return cell;
}
@end
