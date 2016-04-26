//
//  KTVModalView.h
//  KGKtvSdk
//
//  Created by Dng on 16/4/4.
//  Copyright © 2016年 dng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTVModalViewAnimationInStyle) {
    KTVModalViewAnimationInStyleLargen,     //变大
    KTVModalViewAnimationInStyleMcrify,     //变小
    KTVModalViewAnimationInStyleTop,        //从上面滑入
    KTVModalViewAnimationInStyleRight,      //从右边滑入
    KTVModalViewAnimationInStyleBottom,     //从下面滑入
    KTVModalViewAnimationInStyleLeft,       //从左边滑入
    KTVModalViewAnimationInStyleFrom        //从某处出来
};

typedef NS_ENUM(NSInteger, KTVModalViewAnimationOutStyle) {
    KTVModalViewAnimationOutStyleLargen,    //变大
    KTVModalViewAnimationOutStyleMcrify,    //变小
    KTVModalViewAnimationOutStyleTop,       //从上面滑出
    KTVModalViewAnimationOutStyleRight,     //从右边滑出
    KTVModalViewAnimationOutStyleBottom,    //从下面滑出
    KTVModalViewAnimationOutStyleLeft,      //从左边滑出
    KTVModalViewAnimationOutStyleFrom       //回到原处
};

@interface KTVModalView : UIView

/**
 需要自定义的View,默认为空白的View
 */
@property (nonatomic, strong) UIView *customView;

/**
 从某个控件开始变大的源控件
 */
@property (nonatomic, strong) UIView *fromView;

/**
 变大变小时的开始比例，变大时为fromScale，变小时为1/fromScale，1/fromScale最大为值为2
 */
@property (nonatomic, assign) CGFloat fromScale;

/**
 点击底部是否关闭
 */
@property (nonatomic, assign) BOOL backgroundViewClickClose;

/**
 飘入动画
 */
@property (nonatomic, assign) KTVModalViewAnimationInStyle animationInStyle;

/**
 飘出动画
 */
@property (nonatomic, assign) KTVModalViewAnimationOutStyle animationOutStyle;

/**
 是否显示背景
 */
@property (nonatomic, assign) BOOL isShowBackgroundView;

/**
 背景透明度
 */
@property (nonatomic, assign) CGFloat backgroundViewAlpha;

/**
 背景是否需要玻璃模糊效果，默认没有
 */
@property (nonatomic, assign) BOOL blurEffectBackground;

/**
 是否抖动
 */
@property (nonatomic, assign) BOOL isShake;

- (instancetype)initWithCustomView:(UIView *)customView
                          fromView:(UIView *)fromView;

- (void)presentModelViewContainerView:(UIView *)containerView
                            animation:(BOOL)animation
                           completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated
             completion:(void (^)(void))completion;

- (void)dismiss;

@end
