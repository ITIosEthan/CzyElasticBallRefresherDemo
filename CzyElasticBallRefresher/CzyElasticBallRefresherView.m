//
//  CzyElasticBallRefresherView.m
//  CzyElasticBallRefresher
//
//  Created by macOfEthan on 17/7/18.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#define kFullWidth [UIScreen mainScreen].bounds.size.width
#define kFullHeight [UIScreen mainScreen].bounds.size.height
#define kRectangleH 50
#define kRectangleBackGroundColor [UIColor lightGrayColor]

#import "CzyElasticBallRefresherView.h"

@interface CzyElasticBallRefresherView ()

@property (nonatomic, copy) CAShapeLayer *rectangleLayer;
@property (nonatomic, copy) CAShapeLayer *boundceCurveLayer;
@property (nonatomic, copy) CAShapeLayer *ballLayer;

@end

@implementation CzyElasticBallRefresherView

#pragma mark - Setter
- (void)setContentOffSetY:(CGFloat)contentOffSetY
{
    _contentOffSetY = contentOffSetY;
    
    //取消上推绘制
    if (_contentOffSetY >= -50) {
        return;
    }
    
    //绘制矩形
    if (_contentOffSetY <= 0 && _contentOffSetY >= -50) {
        [self rectangleWithOffsetY:_contentOffSetY];
    }
    
    //动态绘制曲线
    if (_contentOffSetY <= -50) {
        
        NSLog(@"曲线_contentOffSetY = %f", _contentOffSetY);
        
        [self bottmCurveWithControlPoint:CGPointMake(kFullWidth/2, -_contentOffSetY)];
    }
    
    //小球
    if (_contentOffSetY <= -50) {
        [self ballWithPoint:_contentOffSetY];
    }
}

#pragma mark - initWithFrame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _rectangleLayer = [CAShapeLayer layer];
        _boundceCurveLayer = [CAShapeLayer layer];
        _ballLayer = [CAShapeLayer layer];
        
        [self rectangleWithOffsetY:0];
        [self bottmCurveWithControlPoint:CGPointMake(kFullWidth/2, 50)];
        [self ballWithPoint:50-30];
        
        [self.layer addSublayer:_rectangleLayer];
        [self.layer addSublayer:_boundceCurveLayer];
        [self.layer insertSublayer:_ballLayer above:_boundceCurveLayer];
    }
    return self;
}

#pragma mark - 绘制矩形
- (void)rectangleWithOffsetY:(CGFloat)offsetY
{
    UIBezierPath *b1 = [UIBezierPath bezierPath];
    [b1 moveToPoint:CGPointMake(0, 0)];
    [b1 addLineToPoint:CGPointMake(kFullWidth, 0)];
    [b1 addLineToPoint:CGPointMake(kFullWidth, offsetY+50)];
    [b1 addLineToPoint:CGPointMake(0, offsetY+50)];
    [b1 fill];
    
    _rectangleLayer.fillColor = kRectangleBackGroundColor.CGColor;
    _rectangleLayer.path = b1.CGPath;
}

#pragma mark - 绘制曲线
- (void)bottmCurveWithControlPoint:(CGPoint)controlPoint
{
    UIBezierPath *b2 = [UIBezierPath bezierPath];
    [b2 moveToPoint:CGPointMake(0, 50)];
    [b2 addQuadCurveToPoint:CGPointMake(kFullWidth, 50) controlPoint:controlPoint];
    [b2 fill];
    
    _boundceCurveLayer.fillColor = kRectangleBackGroundColor.CGColor;
    _boundceCurveLayer.path = b2.CGPath;
}

#pragma mark - 弹球
- (void)ballWithPoint:(CGFloat)ballPointY
{
    _ballLayer.frame = CGRectMake(kFullWidth/2-30/2, (-ballPointY-30)/2, 30, 30);
    _ballLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"ball"].CGImage);
    _ballLayer.cornerRadius = 30/2;
    _ballLayer.masksToBounds = YES;
    _ballLayer.backgroundColor = [UIColor redColor].CGColor;
}

#pragma mark - 开始
- (void)startRotatiton
{
    CABasicAnimation *rotation = [self startRotation];
    [_ballLayer addAnimation:rotation forKey:@"rotation"];
}

- (void)startBoundce
{
    CAKeyframeAnimation *position = [self positionAnimation];
    [_ballLayer addAnimation:position forKey:@"position"];
}

#pragma mark - 停止
- (void)stopRotation
{
    [_ballLayer removeAnimationForKey:@"rotation"];
}

- (void)stopBoundce
{
    [_ballLayer removeAnimationForKey:@"position"];
}


#pragma mark - 位移动画
- (CAKeyframeAnimation *)positionAnimation
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 1.0;
    positionAnimation.repeatCount = 1;
    positionAnimation.autoreverses = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return positionAnimation;
}

#pragma mark - 旋转动画
- (CABasicAnimation *)startRotation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(M_PI*2);
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return rotationAnimation;
}

@end
