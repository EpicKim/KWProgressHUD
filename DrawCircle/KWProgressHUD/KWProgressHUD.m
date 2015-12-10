//
//  KWAnimationView.m
//  DrawCircle
//
//  Created by wangk on 15/12/10.
//  Copyright © 2015年 Yeming. All rights reserved.
//

#import "KWProgressHUD.h"

#define KW_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define DEGREES_TO_RADIANS(angle)                         ((angle * M_PI) / 180.0 )

#define KW_ANIMATE_DURATION                               0.75
#define KW_FIRST_ANIMATION_START_ANGLE                    330
#define KW_FIRST_ANIMATION_END_ANGLE                      90
#define KW_HUD_RADIUS                                     25
#define KW_HUD_CIRCLE_WIDTH                               2

@interface KWAnimationObject : NSObject
+ (instancetype)objectWithSel:(SEL)selector;
@property (nonatomic, assign) SEL selector;
@end

@implementation KWAnimationObject
+ (instancetype)objectWithSel:(SEL)selector {
    KWAnimationObject *animationObject = [[KWAnimationObject alloc] init];
    animationObject.selector = selector;
    return animationObject;
}
@end

@interface KWBackgroundView : UIView

@end

@implementation KWBackgroundView

@end
@interface KWProgressHUD() {
    CGFloat       _rotatedAngle;
    CATransform3D _lastTransform;
    UIView        *_baseView;
    UIColor       *_circleColor;
    int           _animationCount;
}
@property (nonatomic, strong) NSMutableArray *animationSelectorArray;
@end

@implementation KWProgressHUD

#pragma mark - Public Method
+ (void)showToView:(UIView *)view
             color:(UIColor *)color
             image:(UIImage *)image {
    CGRect baseRect = view.frame;
    int hudWidth = KW_HUD_RADIUS * 2;
    int hudHeight = KW_HUD_RADIUS * 2;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect hudRect = CGRectMake((baseRect.size.width - hudWidth)/2,
                                (screenRect.size.height - hudHeight)/2 - 64,
                                hudWidth,
                                hudHeight);
    KWBackgroundView *backgroundView = [[KWBackgroundView alloc] init];
    backgroundView.backgroundColor = view.backgroundColor;
    backgroundView.frame = hudRect;
    
    KWProgressHUD *hud = [[KWProgressHUD alloc] init];
    hud.frame = CGRectMake(0,
                           0,
                           hudWidth,
                           hudHeight);;
    if (color) {
        hud->_circleColor = color;
    }
    hud.backgroundColor = [UIColor clearColor];
    [hud initAnimation];
    hud->_baseView = view;
    [hud->_baseView addSubview:backgroundView];
    [backgroundView addSubview:hud];
    
    // set image
    if (image) {
        int imageWidth = image.size.width/2;
        int imageHeight = image.size.height/2;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake((hudWidth - imageWidth)/2,
                                     (hudHeight - imageHeight)/2,
                                     imageWidth,
                                     imageHeight);
        [backgroundView insertSubview:imageView belowSubview:hud];
    }
    
    [hud startCycleAnimation];
}

+ (void)hidForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[KWBackgroundView class]]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!flag) {
        return;
    }
    _animationCount ++;
    _animationCount = _animationCount % 4;
    if (_animationCount == 0) {
        [self setupAnimation];
    }
    KWAnimationObject *animationObject = [self.animationSelectorArray objectAtIndex:_animationCount];
    if ([self respondsToSelector:animationObject.selector]) {
        KW_SuppressPerformSelectorLeakWarning(
        [self performSelector:animationObject.selector withObject:nil]
        );
    }
}


#pragma mark - Animation Life Circle
- (void)initAnimation {
    _lastTransform = CATransform3DIdentity;
    
    _animationCount = 0;
    self.animationSelectorArray = [[NSMutableArray alloc] init];
    [self.animationSelectorArray addObject:[KWAnimationObject objectWithSel:@selector(firstAnimation)]];
    [self.animationSelectorArray addObject:[KWAnimationObject objectWithSel:@selector(secondAnimation)]];
    [self.animationSelectorArray addObject:[KWAnimationObject objectWithSel:@selector(thirdAnimation)]];
    [self.animationSelectorArray addObject:[KWAnimationObject objectWithSel:@selector(forthAnimation)]];
    
}

- (void)startCycleAnimation {
    [self setupAnimation];
    [self firstAnimation];
}

#pragma mark - Animation
- (void)setupAnimation {
    NSArray *layers = self.layer.sublayers;
    for (int i = 0; i < layers.count; i++) {
        CAShapeLayer *layer = [layers objectAtIndex:i];
        [layer removeFromSuperlayer];
    }
    [self animateWithStartAngle:KW_FIRST_ANIMATION_START_ANGLE + _rotatedAngle
                       endAngle:KW_FIRST_ANIMATION_END_ANGLE + _rotatedAngle
                    strokeColor:[self circleColor]
                      lineWidth:KW_HUD_CIRCLE_WIDTH
                      clockwise:YES
                       duration:0];
}

- (void)firstAnimation {
    [self animateWithStartAngle:KW_FIRST_ANIMATION_START_ANGLE + _rotatedAngle + 1
                       endAngle:KW_FIRST_ANIMATION_END_ANGLE + 10 + _rotatedAngle
                    strokeColor:[self eraseColor]
                      lineWidth:KW_HUD_CIRCLE_WIDTH * 2
                      clockwise:YES
                       duration:KW_ANIMATE_DURATION];
    
    [self rotateWithAngle:45];
}

- (void)secondAnimation {
    [self animateWithStartAngle:45 + _rotatedAngle
                       endAngle:50 + _rotatedAngle
                    strokeColor:[self circleColor]
                      lineWidth:KW_HUD_CIRCLE_WIDTH
                      clockwise:YES
                       duration:KW_ANIMATE_DURATION];
    
    [self rotateWithAngle:90];
}

- (void)thirdAnimation {
    [self animateWithStartAngle:-40 + _rotatedAngle
                       endAngle:-30 + _rotatedAngle
                    strokeColor:[self eraseColor]
                      lineWidth:KW_HUD_CIRCLE_WIDTH * 2
                      clockwise:YES
                       duration:KW_ANIMATE_DURATION];
    
    [self rotateWithAngle:180];
}

- (void)forthAnimation {
    [self animateWithStartAngle:150 + _rotatedAngle
                       endAngle:-90 + _rotatedAngle
                    strokeColor:[self circleColor]
                      lineWidth:KW_HUD_CIRCLE_WIDTH
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
    [self.layer addSublayer:shapeLayer];
    shapeLayer.path = path.CGPath;//46,169,230
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = width;
    shapeLayer.frame = _baseView.frame;
    
    if (duration > 0) {
        CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        bas.duration = duration;
        bas.delegate = self;
        bas.fromValue = [NSNumber numberWithInteger:0];
        bas.toValue = [NSNumber numberWithInteger:1];
        [shapeLayer addAnimation:bas forKey:@"key"];
    }
}

- (void)rotateWithAngle:(float)angle {
    _rotatedAngle += angle;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:KW_ANIMATE_DURATION];
    [UIView setAnimationDelegate:self];
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

- (UIColor *)eraseColor {
    return _baseView.backgroundColor;
}

@end
