//
//  KTVCircleProgressView.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/18.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVCircleProgressView.h"
#import "pop.h"

@interface KTVCircleProgressView()
@property(nonatomic) CAShapeLayer *circleLayer;
- (void)addCircleLayer;
- (void)animateToStrokeEnd:(CGFloat)strokeEnd;
@end

@implementation KTVCircleProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(frame.size.width == frame.size.height, @"A circle must have the same height and width.");
        [self addCircleLayer];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)setStrokeStart:(CGFloat)strokeStart animated:(BOOL)animated {
    if (animated) {
        [self animateToStrokeStart:strokeStart];
        return;
    }
    self.circleLayer.strokeStart = strokeStart;
}

- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated {
    if (animated) {
        [self animateToStrokeEnd:strokeEnd];
        return;
    }
    self.circleLayer.strokeEnd = strokeEnd;
}

- (void)setStrokeColor:(UIColor *)strokeColor animated:(BOOL)animated {
    if (animated) {
        [self animateToStrokeColor:strokeColor];
        return;
    }
    self.circleLayer.strokeColor = strokeColor.CGColor;
}

- (void)setStrokeLineWidth:(CGFloat)strokeLineWidth animated:(BOOL)animated {
    if (animated) {
        [self animateToStrokeLineWidth:strokeLineWidth];
        return;
    }
    self.circleLayer.lineWidth = strokeLineWidth;
}

- (void)setStrokeLineCap:(NSString *)lineCap {
    self.circleLayer.lineCap = lineCap;
}

- (void)setStrokeLineJoin:(NSString *)lineJoin {
    self.circleLayer.lineJoin = lineJoin;
}

#pragma mark - Property Setters

- (void)setStrokeColor:(UIColor *)strokeColor
{
    self.circleLayer.strokeColor = strokeColor.CGColor;
    _strokeColor = strokeColor;
}

#pragma mark - Private Instance methods

- (void)addCircleLayer
{
    CGFloat lineWidth = 4.f;
    CGFloat radius = CGRectGetWidth(self.bounds)/2 - lineWidth/2;
    self.circleLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius * 2, radius * 2);
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                       cornerRadius:radius].CGPath;
    
    self.circleLayer.strokeColor = self.tintColor.CGColor;
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineWidth = lineWidth;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:self.circleLayer];
}

- (void)animateToStrokeStart:(CGFloat)strokeStart {
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeStart];
    strokeAnimation.toValue = @(strokeStart);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimationStart"];
}

- (void)animateToStrokeEnd:(CGFloat)strokeEnd {
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(strokeEnd);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimationEnd"];
}

- (void)animateToStrokeColor:(UIColor *)color {
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeColor];
    strokeAnimation.toValue = (__bridge id)color.CGColor;
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimationColor"];
}

- (void)animateToStrokeLineWidth:(CGFloat)lineWidth {
    POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerLineWidth];
    strokeAnimation.toValue = @(lineWidth);
    strokeAnimation.springBounciness = 12.f;
    strokeAnimation.removedOnCompletion = NO;
    [self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimationLineWidth"];
}

@end
