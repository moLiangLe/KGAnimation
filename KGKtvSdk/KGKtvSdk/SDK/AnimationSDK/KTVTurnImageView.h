//
//  KTVTurnImageView.h
//  KGKtvSdk
//
//  Created by Dng on 16/4/25.
//  Copyright © 2016年 dng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTVTurnImageViewRotation) {
    KTVTurnImageViewRotationY,
    KTVTurnImageViewRotationX
};

@interface KTVTurnImageView : UIImageView

@property (nonatomic, strong) UIImage *nornalImage;
@property (nonatomic, strong) UIImage *turnImage;

@property (nonatomic, assign) KTVTurnImageViewRotation rotation;

- (void)turnWithAnimated:(BOOL)animated;

@end
