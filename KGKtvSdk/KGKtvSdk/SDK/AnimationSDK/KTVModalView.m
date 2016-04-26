//
//  KTVModalView.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/4.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVModalView.h"
#import "pop.h"

typedef NS_ENUM(NSInteger, KTVModelViewAnimationType) {
    KTVModelViewAnimationTypeIn,        //弹入
    KTVModelViewAnimationTypeOut        //弹出
};

#define kBackgroundViewAlpheShow    (_isShowBackgroundView ? (_blurEffectBackground ? @(1.0f) : @(self.backgroundViewAlpha)) : @(0.0))
#define kBackgroundViewAlpheHide    (@(0))
#define kBackgroundView             (_blurEffectBackground ? _visualEffectBackgroundView : _defultBackgroundView)

#define kCustomViewScalePointValueSmall     ([NSValue valueWithCGPoint:CGPointMake(0.5f, 0.5f)])
#define kCustomViewScalePointValueMiddle    ([NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)])
#define kCustomViewScalePointValueBig       ([NSValue valueWithCGPoint:CGPointMake(2.0f, 2.0f)])

#define kCustomViewPositionPointValueTop    \
        ([NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y - CGRectGetHeight(self.frame))])
#define kCustomViewPositionPointValueRight  \
        ([NSValue valueWithCGPoint:CGPointMake(self.center.x + CGRectGetWidth(self.frame), self.center.y)])
#define kCustomViewPositionPointValueBottom \
        ([NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + CGRectGetHeight(self.frame))])
#define kCustomViewPositionPointValueLeft   \
        ([NSValue valueWithCGPoint:CGPointMake(self.center.x - CGRectGetWidth(self.frame), self.center.y)])
#define kCustomViewPositionPointValueMiddle \
        ([NSValue valueWithCGPoint:self.center])

typedef NS_ENUM(NSInteger, KTVModalViewSubviewType) {
    KTVModalViewSubviewTypeBackgroundView,
    KTVModalViewSubviewTypeCustomView
};

@interface KTVModalView() {
    BOOL _animation;
    CGRect _beginAnimRect;
}

/**
 玻璃模糊背景
 */
@property (nonatomic, strong) UIVisualEffectView *visualEffectBackgroundView;

/**
 默认背景
 */
@property (nonatomic, strong) UIView *defultBackgroundView;

/**
 容器
 */
@property (nonatomic, strong) UIView *containerView;

/**
 弹入或弹出
 */
@property (nonatomic, assign) KTVModelViewAnimationType type;

@end

@implementation KTVModalView

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView fromView:(UIView *)fromView {
    if (self = [super init]) {
        _customView = customView;
        _fromView = fromView;
        
        if (fromView) {
            //如果有fromView则动画类型默认为From
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            _beginAnimRect = [window convertRect:_fromView.frame fromView:_fromView.superview];
        }
        
        
        [self setupViews];
        
        if (customView) {
            [_containerView addSubview:customView];
        }
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.isShowBackgroundView = YES;
    self.backgroundViewAlpha = 0.4;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _visualEffectBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _visualEffectBackgroundView.alpha = 0;
    [self addSubview:_visualEffectBackgroundView];
    
    _defultBackgroundView = [[UIView alloc] init];
    _defultBackgroundView.backgroundColor = [UIColor blackColor];
    _defultBackgroundView.alpha = 0.0;
    [self addSubview:_defultBackgroundView];
    
    _containerView = [[UIView alloc] init];
    _containerView.alpha = 0.0;
    [self addSubview:_containerView];
    
    _backgroundViewClickClose = YES;
    
    UITapGestureRecognizer *backgroundViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:backgroundViewTap];
    
    UITapGestureRecognizer *customViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewTap)];
    [self.customView addGestureRecognizer:customViewTap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _visualEffectBackgroundView.frame = self.bounds;
    _defultBackgroundView.frame = self.bounds;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    
    if (customView) {
        [_containerView addSubview:customView];
    }
}

- (void)setFromView:(UIView *)fromView {
    
}

- (void)dismiss {
    if (_backgroundViewClickClose) {
        [self dismissAnimated:_animation completion:nil];
    }
}

- (void)customViewTap {
    NSLog(@"customView tap");
}

- (void)presentModelViewContainerView:(UIView *)containerView
                            animation:(BOOL)animation
                           completion:(void (^)(void))completion {
    if (!_customView) {
        NSLog(@"no custom view");
        return;
    }
    
    _animation = animation;
    
    if (!containerView) {
        containerView = [[UIApplication sharedApplication] keyWindow];
    }
    self.frame = containerView.bounds;
    [containerView addSubview:self];
    
    if (_customView) {
        _containerView.bounds = CGRectMake(0, 0, CGRectGetWidth(_customView.frame), CGRectGetHeight(_customView.frame));
        _containerView.center = self.center;
    } else {
        _containerView.frame = CGRectZero;
    }
    
    if (animation) {
        [self animationWithSubviewType:KTVModalViewSubviewTypeBackgroundView inOrOut:KTVModelViewAnimationTypeIn completion:completion];
        
        [self animationWithSubviewType:KTVModalViewSubviewTypeCustomView inOrOut:KTVModelViewAnimationTypeIn completion:completion];
    } else {
        [self stateChange:YES];
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (animated) {
        [self animationWithSubviewType:KTVModalViewSubviewTypeBackgroundView inOrOut:KTVModelViewAnimationTypeOut completion:completion];
        
        [self animationWithSubviewType:KTVModalViewSubviewTypeCustomView inOrOut:KTVModelViewAnimationTypeOut completion:completion];
    } else {
        [self stateChange:NO];
    }
}

- (void)stateChange:(BOOL)present {
    UIView *backgroundView = kBackgroundView;
    if (present) {
        backgroundView.alpha = [kBackgroundViewAlpheShow floatValue];
        self.hidden = NO;
    } else {
        backgroundView.alpha = [kBackgroundViewAlpheHide floatValue];;
        self.hidden = YES;
    }
}

- (void)animationWithSubviewType:(KTVModalViewSubviewType)subviewType
                         inOrOut:(KTVModelViewAnimationType)animationType
                      completion:(void (^)(void))completion {
    //背景
    if (subviewType == KTVModalViewSubviewTypeBackgroundView) {
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        
        //飘入
        if (animationType == KTVModelViewAnimationTypeIn) {
            anim.springBounciness = 10;
            anim.springSpeed = 20;
            anim.fromValue = kBackgroundViewAlpheHide;
            anim.toValue = kBackgroundViewAlpheShow;
            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    self.hidden = NO;
                    if (completion) {
                        completion();
                    }
                }
            };
        }
        
        //飘出
        if (animationType == KTVModelViewAnimationTypeOut) {
            anim.springBounciness = 10;
            anim.springSpeed = 20;
            anim.fromValue = kBackgroundViewAlpheShow;
            anim.toValue = kBackgroundViewAlpheHide;
            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    self.hidden = YES;
                    if (completion) {
                        completion();
                    }
                }
            };
        }
        
        UIView *backgroundView = kBackgroundView;
        [backgroundView pop_addAnimation:anim forKey:@"backgroundViewAlpha"];
    }
    
    //自定义View
    if (subviewType == KTVModalViewSubviewTypeCustomView) {
        
        POPSpringAnimation *animAlpha = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        
        //飘入
        if (animationType == KTVModelViewAnimationTypeIn) {
            
            animAlpha.springBounciness = 10;
            animAlpha.springSpeed = 20;
            animAlpha.fromValue = @(0);
            animAlpha.toValue = @(1);
            animAlpha.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    self.hidden = NO;
                    if (completion) {
                        completion();
                    }
                }
            };
            
            switch (self.animationInStyle) {
                case KTVModalViewAnimationInStyleTop: {
                    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                    anim.springBounciness = 10;
                    anim.springSpeed = 20;
                    anim.fromValue = kCustomViewPositionPointValueTop;
                    anim.toValue = kCustomViewPositionPointValueMiddle;
                    [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYInTop"];
                }
                    break;
                    
                case KTVModalViewAnimationInStyleRight: {
                    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                    anim.springBounciness = 10;
                    anim.springSpeed = 20;
                    anim.fromValue = kCustomViewPositionPointValueRight;
                    anim.toValue = kCustomViewPositionPointValueMiddle;
                    [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYInRight"];
                }
                    break;
                    
                case KTVModalViewAnimationInStyleBottom: {
                    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                    anim.springBounciness = 10;
                    anim.springSpeed = 20;
                    anim.fromValue = kCustomViewPositionPointValueBottom;
                    anim.toValue = kCustomViewPositionPointValueMiddle;
                    [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYInBottom"];
                }
                    break;
                    
                case KTVModalViewAnimationInStyleLeft: {
                    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                    anim.springBounciness = 10;
                    anim.springSpeed = 20;
                    anim.fromValue = kCustomViewPositionPointValueLeft;
                    anim.toValue = kCustomViewPositionPointValueMiddle;
                    [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYInLeft"];
                }
                    break;
                    
                case KTVModalViewAnimationInStyleLargen: {
                    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                    anim.springBounciness = 10;
                    anim.springSpeed = 20;
                    anim.fromValue = kCustomViewScalePointValueSmall;
                    anim.toValue = kCustomViewScalePointValueMiddle;
                    [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYInLargen"];
                }
                    break;
                    
                case KTVModalViewAnimationInStyleMcrify: {
                    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                    anim.springBounciness = 10;
                    anim.springSpeed = 20;
                    anim.fromValue = kCustomViewScalePointValueBig;
                    anim.toValue = kCustomViewScalePointValueMiddle;
                    [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYInMcrify"];
                }
                    break;
                    
                case KTVModalViewAnimationInStyleFrom: {
                    NSValue *beginScaleValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(_beginAnimRect) / CGRectGetWidth(_containerView.frame), CGRectGetHeight(_beginAnimRect) / CGRectGetHeight(_containerView.frame))];
                    NSValue *endScaleValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];;
                    
                    NSValue *beginPositionValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetMinX(_beginAnimRect) + CGRectGetMaxX(_beginAnimRect)) / 2.0, (CGRectGetMinY(_beginAnimRect) + CGRectGetMaxY(_beginAnimRect)) / 2.0)];
                    NSValue *endPositionValue = [NSValue valueWithCGPoint:_containerView.center];
                    
                    POPSpringAnimation *animBounds = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                    animBounds.springBounciness = 10;
                    animBounds.springSpeed = 20;
                    animBounds.fromValue = beginScaleValue;
                    animBounds.toValue = endScaleValue;
                    [_containerView.layer pop_addAnimation:animBounds forKey:@"customViewScaleXYFromBounds"];
                    
                    POPSpringAnimation *animPosition = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                    animPosition.springBounciness = 10;
                    animPosition.springSpeed = 20;
                    animPosition.fromValue = beginPositionValue;
                    animPosition.toValue = endPositionValue;
                    [_containerView.layer pop_addAnimation:animPosition forKey:@"customViewScaleXYFromPosition"];
                }
                    break;
                    
                default:
                    break;
            }
            
            if (self.isShake) {
                POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
                springAnimation.fromValue = @(M_PI / 64.0);
                springAnimation.toValue = @(0);
                springAnimation.springBounciness = 20;
                springAnimation.velocity = @(10);
                [_customView.layer pop_addAnimation:springAnimation forKey:@"customViewRotation"];
            }
        }
        
        //飘出
        if (animationType == KTVModelViewAnimationTypeOut) {
            
            animAlpha.springBounciness = 5;
            animAlpha.springSpeed = 20;
            animAlpha.fromValue = @(1);
            animAlpha.toValue = @(0);
            animAlpha.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    self.hidden = YES;
                    [self removeFromSuperview];
                    if (completion) {
                        completion();
                    }
                }
            };
            
            if (animationType == KTVModelViewAnimationTypeOut) {
                switch (self.animationOutStyle) {
                    case KTVModalViewAnimationOutStyleTop: {
                        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                        anim.springBounciness = 10;
                        anim.springSpeed = 20;
                        anim.fromValue = kCustomViewPositionPointValueMiddle;
                        anim.toValue = kCustomViewPositionPointValueTop;
                        [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYOutTop"];
                    }
                        break;
                        
                    case KTVModalViewAnimationOutStyleRight: {
                        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                        anim.springBounciness = 10;
                        anim.springSpeed = 20;
                        anim.fromValue = kCustomViewPositionPointValueMiddle;
                        anim.toValue = kCustomViewPositionPointValueRight;
                        [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYOutRight"];
                    }
                        break;
                        
                    case KTVModalViewAnimationOutStyleBottom: {
                        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                        anim.springBounciness = 10;
                        anim.springSpeed = 20;
                        anim.fromValue = kCustomViewPositionPointValueMiddle;
                        anim.toValue = kCustomViewPositionPointValueBottom;
                        [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYOutBottom"];
                    }
                        break;
                        
                    case KTVModalViewAnimationOutStyleLeft: {
                        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                        anim.springBounciness = 10;
                        anim.springSpeed = 20;
                        anim.fromValue = kCustomViewPositionPointValueMiddle;
                        anim.toValue = kCustomViewPositionPointValueLeft;
                        [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYOutLeft"];
                    }
                        break;
                        
                    case KTVModalViewAnimationOutStyleLargen: {
                        
                        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                        anim.springBounciness = 10;
                        anim.springSpeed = 20;
                        anim.fromValue = kCustomViewScalePointValueMiddle;
                        anim.toValue = kCustomViewScalePointValueBig;
                        [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYOutLargen"];
                    }
                        break;
                        
                    case KTVModalViewAnimationOutStyleMcrify: {
                        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                        anim.springBounciness = 10;
                        anim.springSpeed = 20;
                        anim.fromValue = kCustomViewScalePointValueMiddle;
                        anim.toValue = kCustomViewScalePointValueSmall;
                        [_containerView.layer pop_addAnimation:anim forKey:@"customViewScaleXYOutMcrify"];
                    }
                        break;
                        
                    case KTVModalViewAnimationOutStyleFrom: {
                        NSValue *beginScaleValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(_beginAnimRect) / CGRectGetWidth(_containerView.frame), CGRectGetHeight(_beginAnimRect) / CGRectGetHeight(_containerView.frame))];
                        NSValue *endScaleValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];;
                        
                        NSValue *beginPositionValue = [NSValue valueWithCGPoint:CGPointMake((CGRectGetMinX(_beginAnimRect) + CGRectGetMaxX(_beginAnimRect)) / 2.0, (CGRectGetMinY(_beginAnimRect) + CGRectGetMaxY(_beginAnimRect)) / 2.0)];
                        NSValue *endPositionValue = [NSValue valueWithCGPoint:_containerView.center];
                        
                        POPSpringAnimation *animBounds = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                        animBounds.springBounciness = 10;
                        animBounds.springSpeed = 20;
                        animBounds.fromValue = endScaleValue;
                        animBounds.toValue = beginScaleValue;
                        [_containerView.layer pop_addAnimation:animBounds forKey:@"customViewScaleXYFromBounds"];
                        
                        POPSpringAnimation *animPosition = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                        animPosition.springBounciness = 10;
                        animPosition.springSpeed = 20;
                        animPosition.fromValue = endPositionValue;
                        animPosition.toValue = beginPositionValue;
                        [_containerView.layer pop_addAnimation:animPosition forKey:@"customViewScaleXYFromPosition"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        
        [_containerView pop_addAnimation:animAlpha forKey:@"customViewAlpha"];
    }
}

@end
