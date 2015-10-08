//
//  SYSearchResultsViewController.m
//  SYSearchBar
//
//  Created by Sean Yue on 15/10/7.
//  Copyright © 2015年 Yu Xulu. All rights reserved.
//

#import "SYSearchResultsViewController.h"

@interface SYSearchResultsViewController ()
{
    UITableView *_resultsTableView;
}
@end

@implementation SYSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _resultsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _resultsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_resultsTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
