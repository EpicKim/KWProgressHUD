//
//  ViewController.m
//  DrawCircle
//
//  Created by Yeming on 13-8-27.
//  Copyright (c) 2013年 Yeming. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KWAnimationView.h"

@interface ViewController ()
{
    BOOL _isIntroduceVC;
    NSInteger numberOfHeight;
    BOOL _isIos5;
    BOOL _isAnimation;
    BOOL _isPressButton;
    
}
@property (weak, nonatomic) IBOutlet KWAnimationView *animationView;
@end

@implementation ViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click
- (IBAction)eraseAction:(id)sender {
//    self.animationView.transform = CGAffineTransformIdentity;
//    [self initAnimation];
    
}

- (IBAction)draw:(id)sender {
    [self.animationView showHUDAddedToView:self.view];
}

@end
