//
//  ViewController.m
//  DrawCircle
//
//  Created by Yeming on 13-8-27.
//  Copyright (c) 2013年 Yeming. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ARC_WIDHT 3
#define DEGREES_TO_RADIANS(angle) ((angle * M_PI) / 180.0 )
#define ANIMATE_DURATION          0.75

@interface ViewController ()
{
    CAShapeLayer *_activeLayer;
    CAShapeLayer *_newLayer;
    BOOL _isIntroduceVC;
    NSInteger numberOfHeight;
    BOOL _isIos5;
    BOOL _isAnimation;
    BOOL _isPressButton;
    
}
@property (weak, nonatomic) IBOutlet UIView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self animateWithStartAngle:0
                       endAngle:270
                    strokeColor:[UIColor whiteColor]
                      lineWidth:3
                      clockwise:YES];
}

-(void)animateWithStartAngle:(CGFloat)start
                    endAngle:(CGFloat)end
                 strokeColor:(UIColor *)strokeColor
                   lineWidth:(int)width
                   clockwise:(BOOL)clockwise {
    
    CGFloat startAngle = start;
    CGFloat endAngle = end;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(100, 100)
                    radius:30
                startAngle:DEGREES_TO_RADIANS(startAngle)
                  endAngle:DEGREES_TO_RADIANS(endAngle)
                 clockwise:clockwise];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    if (!_activeLayer) {
        _activeLayer = shapeLayer;
    }
    else {
        _newLayer = shapeLayer;
    }
    [self.animationView.layer addSublayer:shapeLayer];
    shapeLayer.path = path.CGPath;//46,169,230
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = width;
    shapeLayer.frame = self.view.frame;
    [self drawLineAnimation:shapeLayer];
}

-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = ANIMATE_DURATION;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

#pragma mark - Button Click
- (IBAction)eraseAction:(id)sender {
    [self animateWithStartAngle:0
                       endAngle:270 - 30
                    strokeColor:self.animationView.backgroundColor
                      lineWidth:6
                      clockwise:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.animationView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(90), 0, 0, 1);
    [UIView commitAnimations];
}

- (IBAction)draw:(id)sender {
    [self animateWithStartAngle:0
                       endAngle:270
                    strokeColor:[UIColor whiteColor]
                      lineWidth:3
                      clockwise:YES];
}

#pragma mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    if (_newLayer) {
//        [_activeLayer removeFromSuperlayer];
//        _activeLayer = _newLayer;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
