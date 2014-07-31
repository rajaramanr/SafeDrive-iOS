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
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *violations = [[NSMutableArray alloc] init];
    ViolationDAO *violateData = [[ViolationDAO alloc] init];
    violations = [violateData getViolations];
    for (Violation *vio in violations) {
        NSLog(vio.dateOfViolation);
    }
    self.dates = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    self.violations=@[@"2",@"4",@"1",@"0",@"8",@"3",@"5",@"0",@"1",@"2",@"1",@"1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
