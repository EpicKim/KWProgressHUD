//
//  KWAnimationView.m
//  DrawCircle
//
//  Created by wangk on 15/12/10.
//  Copyright © 2015年 Yeming. All rights reserved.
//

#import "KWProgressHUD.h"

#define DEGREES_TO_RADIANS(angle)                         ((angle * M_PI) / 180.0 )

#define KW_ANIMATE_DURATION                               0.75
#define KW_FIRST_ANIMATION_START_ANGLE                    330
#define KW_FIRST_ANIMATION_END_ANGLE                      90
#define KW_HUD_RADIUS                                     25

@interface KWProgressHUD() {
    CGFloat       _rotatedAngle;
    CATransform3D _lastTransform;
    CAShapeLayer  *_activeLayer;
    CAShapeLayer  *_newLayer;
    UIView        *_baseView;
    UIColor       *_circleColor;
}
@end

@implementation KWProgressHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Public Method
+ (void)showToView:(UIView *)view
             color:(UIColor *)color {
    CGRect baseRect = view.frame;
    int hudWidth = KW_HUD_RADIUS * 2;
    int hudHeight = KW_HUD_RADIUS * 2;
    KWProgressHUD *hud = [[KWProgressHUD alloc] init];
    hud.frame = CGRectMake((baseRect.size.width - hudWidth)/2,
                           (baseRect.size.height - hudHeight)/2,
                           hudWidth,
                           hudHeight);
    if (color) {
        hud->_circleColor = color;
    }
    hud.backgroundColor = view.backgroundColor;
    [hud initAnimation];
    hud->_baseView = view;
    [hud->_baseView addSubview:hud];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:KW_ANIMATE_DURATION * 4 target:hud selector:@selector(startCycleAnimation) userInfo:nil repeats:YES];
    [timer fire];
}

+ (void)hidForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}


#pragma mark - Animation Life Circle
- (void)initAnimation {
    _lastTransform = CATransform3DIdentity;
    if (_activeLayer) {
        [_activeLayer removeFromSuperlayer];
    }
    [self firstAnimation];
}

- (void)startCycleAnimation {
    [self secondAnimation];
    [NSTimer scheduledTimerWithTimeInterval:KW_ANIMATE_DURATION * 1
                                     target:self
                                   selector:@selector(thirdAnimation)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:KW_ANIMATE_DURATION * 2
                                     target:self
                                   selector:@selector(forthAnimation)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:KW_ANIMATE_DURATION * 3
                                     target:self
                                   selector:@selector(fifthAnimation)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark - Animation
- (void)firstAnimation {
    [self animateWithStartAngle:KW_FIRST_ANIMATION_START_ANGLE
                       endAngle:KW_FIRST_ANIMATION_END_ANGLE
                    strokeColor:[self circleColor]
                      lineWidth:3
                      clockwise:YES
                       duration:0];
}

- (void)secondAnimation {
    [self animateWithStartAngle:KW_FIRST_ANIMATION_START_ANGLE + _rotatedAngle
                       endAngle:KW_FIRST_ANIMATION_END_ANGLE + 10 + _rotatedAngle
                    strokeColor:self.backgroundColor
                      lineWidth:6
                      clockwise:YES
                       duration:KW_ANIMATE_DURATION];
    
    [self rotateWithAngle:45];
}

- (void)thirdAnimation {
    [self animateWithStartAngle:45 + _rotatedAngle
                       endAngle:50 + _rotatedAngle
                    strokeColor:[self circleColor]
                      lineWidth:3
                      clockwise:YES
                       duration:KW_ANIMATE_DURATION];
    
    [self rotateWithAngle:90];
}

- (void)forthAnimation {
    [self animateWithStartAngle:-40 + _rotatedAngle
                       endAngle:-30 + _rotatedAngle
                    strokeColor:self.backgroundColor
                      lineWidth:6
                      clockwise:YES
                       duration:KW_ANIMATE_DURATION];
    
    [self rotateWithAngle:180];
}

- (void)fifthAnimation {
    [self animateWithStartAngle:150 + _rotatedAngle
                       endAngle:-90 + _rotatedAngle
                    strokeColor:[self circleColor]
                      lineWidth:3
                      clockwise:YES
                       duration:KW_ANIMATE_DURATION];
    
    [self rotateWithAngle:180];
}

#pragma mark - Private Animation Method
-(void)animateWithStartAngle:(CGFloat)start
                    endAngle:(CGFloat)end
                 strokeColor:(UIColor *)strokeColor
                   lineWidth:(int)width
                   clockwise:(BOOL)clockwise
                    duration:(float)duration {
    
    CGFloat startAngle = 360 - start;
    CGFloat endAngle = 360 - end;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(KW_HUD_RADIUS, KW_HUD_RADIUS)
                    radius:KW_HUD_RADIUS
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
    [self.layer addSublayer:shapeLayer];
    shapeLayer.path = path.CGPath;//46,169,230
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = width;
    shapeLayer.frame = _baseView.frame;
    
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = duration;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [shapeLayer addAnimation:bas forKey:@"key"];
}

- (void)rotateWithAngle:(float)angle {
    _rotatedAngle += angle;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:KW_ANIMATE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _lastTransform = CATransform3DRotate(_lastTransform, DEGREES_TO_RADIANS(angle) , 0, 0, 1);
    self.layer.transform = _lastTransform;
    [UIView commitAnimations];
}

#pragma mark - Private Method
+ (instancetype)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (KWProgressHUD *)subview;
        }
    }
    return nil;
}

- (UIColor *)circleColor {
    if (_circleColor) {
        return _circleColor;
    }
    else {
        return [UIColor blueColor];
    }
}
@end
