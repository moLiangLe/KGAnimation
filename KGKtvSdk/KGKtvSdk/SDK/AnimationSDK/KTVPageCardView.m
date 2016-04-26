//
//  KTVPageCardView.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/25.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVPageCardView.h"
#import "pop.h"

@interface KTVPageCardView() {
    BOOL _flag;
}

@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *frameS;


@end

@implementation KTVPageCardView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.numberOfShowPage = 3;
    self.cardSpace = 20;
}

- (void)setDatasource:(id<KTVPageCardViewDatasource>)datasource {
    _datasource = datasource;
    
    
    if ([self.datasource respondsToSelector:@selector(numberOfPage)]) {
        self.numberOfPage = [self.datasource numberOfPage];
    }
    
    if ([self.datasource respondsToSelector:@selector(pageCardView:atIndex:)] && self.numberOfPage) {
        if (self.numberOfPage < self.numberOfShowPage) {
            self.numberOfShowPage = self.numberOfPage;
        }
        self.pages = [NSMutableArray array];
        for (NSInteger index = self.numberOfShowPage - 1; index >= 0; index--) {
            UIView *view = [self.datasource pageCardView:self atIndex:index];
            [self addSubview:view];
            [self.pages addObject:view];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    if ([self.delegate respondsToSelector:@selector(sizeOfPageCardView:)]) {
        size = [self.delegate sizeOfPageCardView:self];
        if (size.width == 0 || size.height == 0) {
            size = self.bounds.size;
        }
    }
    _size = size;

    if (!_flag) {
        _frameS = [NSMutableArray array];
        for (NSInteger index = 0; index < self.pages.count; index++) {
            UIView *view = self.pages[index];
            
            CGFloat value =  self.cardSpace * (self.pages.count - index - 1);
            CGRect toRect = CGRectMake(0, 0, size.width - 2 * value, size.height - 2 * value);
            CGPoint fromCenter = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
            CGPoint toCenter = CGPointMake(fromCenter.x, fromCenter.y - 1.5 * value);
            
            view.bounds = toRect;
            view.center = toCenter;
            
            [_frameS addObject:[NSValue valueWithCGRect:view.frame]];
        }
        _flag = YES;
    }
}

- (void)removeForwardCard {
    if (self.pages.count <= 1) {
        return;
    }
    
    UIView *removeView = [self.pages lastObject];
    
    [removeView removeFromSuperview];
    [self.pages removeLastObject];
    
    _currentIndex++;
    
    if (_currentIndex < self.numberOfPage - self.numberOfShowPage) {
        UIView *nextView = [self.datasource pageCardView:self atIndex:_currentIndex + self.numberOfShowPage - 1];
        [self.pages insertObject:nextView atIndex:0];
        [self insertSubview:nextView atIndex:0];
    }
    
    for (NSInteger index = 0; index < self.pages.count; index++) {
        UIView *view = self.pages[index];
        
        NSValue *fromValue;
        NSValue *toValue;
        
        if (self.pages.count < self.numberOfShowPage) {
            NSInteger s = self.numberOfShowPage - self.pages.count;
            fromValue = _frameS[index + s - 1];
            toValue = _frameS[index + s];
        }  else {
            if (index == 0) {
                fromValue = _frameS[self.pages.count - 1];
                toValue = _frameS[0];
            } else {
                fromValue = _frameS[index - 1];
                toValue = _frameS[index];
            }
        }
        POPSpringAnimation *animSXY = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animSXY.fromValue = fromValue;
        animSXY.toValue = toValue;
        animSXY.springBounciness = 0.f;
        animSXY.springSpeed = 20.f;
        [view.layer pop_addAnimation:animSXY forKey:@"kPOPViewFrame"];
    }
}

//- (void)addDragView:(UIView *)view {
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(handlePan:)];
//    
//    view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    view.center = self.center;
//    view.layer.cornerRadius = CGRectGetWidth(self.dragView.bounds)/2;
//    view.backgroundColor = [UIColor customBlueColor];
//    view addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
//    view addGestureRecognizer:recognizer];
//}
//
//- (void)touchDown:(UIControl *)sender {
//    [sender.layer pop_removeAllAnimations];
//}
//
//- (void)handlePan:(UIPanGestureRecognizer *)recognizer
//{
//    CGPoint translation = [recognizer translationInView:self.view];
//    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
//                                         recognizer.view.center.y + translation.y);
//    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
//    
//    if(recognizer.state == UIGestureRecognizerStateEnded) {
//        CGPoint velocity = [recognizer velocityInView:self.view];
//        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
//        positionAnimation.delegate = self;
//        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
//        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
//    }
//}

@end
