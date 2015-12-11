//
//  SecondViewController.m
//  DrawCircle
//
//  Created by wangk on 15/12/11.
//  Copyright © 2015年 Yeming. All rights reserved.
//

#import "SecondViewController.h"
#import "KWProgressHUD.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [KWProgressHUD showToView:self.view
//                        color:[UIColor redColor]
//                        image:nil];
//     [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(test) userInfo:nil repeats:NO];
//    [self test];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self test];
}

- (void)test {
    [KWProgressHUD showToView:self.view
                        color:[UIColor redColor]
                        image:nil];
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
