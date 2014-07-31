//
//  HistoryViewController.h
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) NSMutableArray *dates;
@property (retain,nonatomic) NSMutableArray *violations;
@property (weak, nonatomic) IBOutlet UITableView *Table;

@end
