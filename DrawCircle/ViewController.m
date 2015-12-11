//
//  ViewController.m
//  DrawCircle
//
//  Created by Yeming on 13-8-27.
//  Copyright (c) 2013年 Yeming. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KWProgressHUD.h"
#import "SecondViewController.h"

@interface ViewController ()
{
    BOOL _isIntroduceVC;
    NSInteger numberOfHeight;
    BOOL _isIos5;
    BOOL _isAnimation;
    BOOL _isPressButton;
    
}

@end

@implementation ViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Go"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(pushToNext)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    [self draw:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click
- (IBAction)eraseAction:(id)sender {
    [KWProgressHUD hidForView:self.view];
}

- (IBAction)draw:(id)sender {
    [KWProgressHUD showToView:self.view
                        color:nil
                        image:nil];
}

- (void)pushToNext {
    [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:YES];
}

@end
