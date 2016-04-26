//
//  KTVCircleProgressView.h
//  KGKtvSdk
//
//  Created by Dng on 16/4/18.
//  Copyright © 2016年 dng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTVCircleProgressView : UIView

@property(nonatomic) UIColor *strokeColor;

- (void)setStrokeStart:(CGFloat)strokeStart animated:(BOOL)animated;
- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;
- (void)setStrokeColor:(UIColor *)strokeColor animated:(BOOL)animated;
- (void)setStrokeLineWidth:(CGFloat)strokeLineWidth animated:(BOOL)animated;
- (void)setStrokeLineCap:(NSString *)lineCap;
- (void)setStrokeLineJoin:(NSString *)lineJoin;

@end
