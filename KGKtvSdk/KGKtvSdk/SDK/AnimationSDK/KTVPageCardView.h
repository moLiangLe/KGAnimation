//
//  KTVPageCardView.h
//  KGKtvSdk
//
//  Created by Dng on 16/4/25.
//  Copyright © 2016年 dng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTVPageCardView;

@protocol KTVPageCardViewDelegate <NSObject>

- (CGSize)sizeOfPageCardView:(KTVPageCardView *)pageCardView;

@end

@protocol KTVPageCardViewDatasource <NSObject>

- (NSInteger)numberOfPage;
- (UIView *)pageCardView:(KTVPageCardView *)pageCardView atIndex:(NSInteger)index;

@end

@interface KTVPageCardView : UIView

@property (nonatomic, assign) id<KTVPageCardViewDatasource> datasource;
@property (nonatomic, assign) id<KTVPageCardViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger numberOfPage;
@property (nonatomic, assign) NSUInteger numberOfShowPage;

@property (nonatomic, assign) CGFloat cardSpace;

- (void)removeForwardCard;

@end
