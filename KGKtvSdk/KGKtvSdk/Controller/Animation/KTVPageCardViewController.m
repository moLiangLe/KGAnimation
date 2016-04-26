//
//  KTVPageCardViewController.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/25.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVPageCardViewController.h"
#import "KTVPageCardView.h"

@interface KTVPageCardViewController() <KTVPageCardViewDelegate, KTVPageCardViewDatasource>

@property (nonatomic, strong) KTVPageCardView *pageCardView;

@end

@implementation KTVPageCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageCardView = [[KTVPageCardView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.width)];
    self.pageCardView.delegate = self;
    self.pageCardView.datasource = self;
    [self.view addSubview:self.pageCardView];
}

#pragma mark - 
- (NSInteger)numberOfPage {
    return 12;
}

- (UIView *)pageCardView:(KTVPageCardView *)pageCardView atIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
    return view;
}

- (CGSize)sizeOfPageCardView:(KTVPageCardView *)pageCardView {
    return CGSizeMake(pageCardView.frame.size.width - 60, pageCardView.frame.size.height - 60);
}

- (IBAction)next:(id)sender {
    [self.pageCardView removeForwardCard];
}

@end
