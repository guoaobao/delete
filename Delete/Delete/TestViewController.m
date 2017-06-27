//
//  TestViewController.m
//  Delete
//
//  Created by gab on 17/6/12.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "TestViewController.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%d,%d",self->_testNum,self.testNum1);
    
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
