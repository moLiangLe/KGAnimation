//
//  KTVTurnImageView.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/25.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVTurnImageView.h"
#import "pop.h"

@interface KTVTurnImageView() {
    CGFloat _angel;
    BOOL _turn;
}

@end

@implementation KTVTurnImageView

- (instancetype)initWithNornalImage:(UIImage *)nornalImage turnImage:(UIImage *)turnImage {
    if (self = [super init]) {
        _nornalImage = nornalImage;
        _turnImage = turnImage;
        
        self.image = nornalImage;
    }
    return self;
}

- (void)setNornalImage:(UIImage *)nornalImage {
    _nornalImage = nornalImage;
    self.image = nornalImage;
}

- (void)setTurnImage:(UIImage *)turnImage {
    _turnImage = turnImage;
}

- (void)turnWithAnimated:(BOOL)animated {
    if (animated) {
        POPBasicAnimation *anim = [POPBasicAnimation animation];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.writeBlock = ^(UIImageView *obj, const CGFloat values[]) {
                CGFloat value = values[0];
                CGFloat gap;
                
                if (_turn) {
                    gap = _angel + M_PI_2 - value;
                    static BOOL flag = NO;
                    if (gap <= 0.f) {
                        flag = NO;
                    }
                    if (gap > 0.f && flag == NO) {
                        flag = YES;
                        obj.image = _nornalImage;
                    }
                } else {
                    gap = _angel - M_PI_2 - value;
                    static BOOL flag = NO;
                    if (gap > 0.f) {
                        flag = NO;
                    }
                    if (gap <= 0.f && flag == NO) {
                        flag = YES;
                        obj.image = _turnImage;
                    }
                    
                }
                [self setTransformRotation:value];
            };
            prop.threshold = 1;
        }];
        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                _turn = !_turn;
            }
        };
        anim.property = prop;
        anim.fromValue = @(_angel);
        if (_turn) {
            _angel -= M_PI;
        } else {
            _angel += M_PI;
        }
        anim.toValue = @(_angel);
        
        [self pop_addAnimation:anim forKey:@"kPOPLayerRotationYTurn"];
    }
}

- (void)setTransformRotation:(CGFloat)value {
    switch (_rotation) {
        case KTVTurnImageViewRotationX: {
            [self.layer setTransform:CATransform3DMakeRotation(value, 1, 0, 0)];
        }break;
            
        case KTVTurnImageViewRotationY: {
            [self.layer setTransform:CATransform3DMakeRotation(value, 0, 1, 0)];
        }break;
            
        default:
            break;
    }
    
}

@end
