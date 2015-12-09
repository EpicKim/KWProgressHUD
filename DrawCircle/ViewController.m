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

#define FIRST_ANIMATION_START_ANGLE 330
#define FIRST_ANIMATION_END_ANGLE   90
#define ANIMATION_DRAW_COLOR [UIColor blueColor]

@interface ViewController ()
{
    CAShapeLayer *_activeLayer;
    CAShapeLayer *_newLayer;
    BOOL _isIntroduceVC;
    NSInteger numberOfHeight;
    BOOL _isIos5;
    BOOL _isAnimation;
    BOOL _isPressButton;
    
    CGFloat _rotatedAngle;

    CATransform3D _lastTransform;
}
@property (weak, nonatomic) IBOutlet UIView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
//    [self animateWithStartAngle:30
//                       endAngle:270
//                    strokeColor:[UIColor whiteColor]
//                      lineWidth:3
//                      clockwise:YES];
    self.animationView.backgroundColor = [UIColor whiteColor];
    [self firstAnimation];
    [NSTimer scheduledTimerWithTimeInterval:ANIMATE_DURATION
                                     target:self
                                   selector:@selector(secondAnimation)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:ANIMATE_DURATION * 2
                                     target:self
                                   selector:@selector(thirdAnimation)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:ANIMATE_DURATION * 3
                                     target:self
                                   selector:@selector(forthAnimation)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)animateWithStartAngle:(CGFloat)start
                    endAngle:(CGFloat)end
                 strokeColor:(UIColor *)strokeColor
                   lineWidth:(int)width
                   clockwise:(BOOL)clockwise {
    
    CGFloat startAngle = 360 - start;
    CGFloat endAngle = 360 - end;

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
    [self animateWithStartAngle:30
                       endAngle:270 - 30
                    strokeColor:self.animationView.backgroundColor
                      lineWidth:6
                      clockwise:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.animationView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(45), 0, 0, 1);
    [UIView commitAnimations];
}

//- (IBAction)draw:(id)sender {
//    [self animateWithStartAngle:0
//                       endAngle:270
//                    strokeColor:[UIColor whiteColor]
//                      lineWidth:3
//                      clockwise:YES];
//}

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
#pragma mark - Animation 
- (void)firstAnimation {
    [self animateWithStartAngle:FIRST_ANIMATION_START_ANGLE
                       endAngle:FIRST_ANIMATION_END_ANGLE
                    strokeColor:ANIMATION_DRAW_COLOR
                      lineWidth:3
                      clockwise:YES];
}

- (void)secondAnimation {
    [self animateWithStartAngle:FIRST_ANIMATION_START_ANGLE
                       endAngle:FIRST_ANIMATION_END_ANGLE + 10
                    strokeColor:self.animationView.backgroundColor
                      lineWidth:6
                      clockwise:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _lastTransform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(45), 0, 0, 1);
    self.animationView.layer.transform = _lastTransform;
    [UIView commitAnimations];
    _rotatedAngle += 45;
}

- (void)thirdAnimation {
    [self animateWithStartAngle:45 + _rotatedAngle
                       endAngle:50 + _rotatedAngle
                    strokeColor:ANIMATION_DRAW_COLOR
                      lineWidth:3
                      clockwise:YES];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _lastTransform = CATransform3DRotate(_lastTransform, 90, 0, 0, 1);

//    self.animationView.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(45+90), 0, 0, 1);
    self.animationView.layer.transform = _lastTransform;
    [UIView commitAnimations];
}

- (void)forthAnimation {
    [self animateWithStartAngle:50 + _rotatedAngle
                       endAngle:50 + _rotatedAngle + 10
                    strokeColor:self.animationView.backgroundColor
                      lineWidth:6
                      clockwise:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _lastTransform = CATransform3DRotate(_lastTransform, 90 + 45, 0, 0, 1);
    self.animationView.layer.transform = _lastTransform;
    [UIView commitAnimations];
}

@end
