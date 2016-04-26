//
//  KTVModalViewController.m
//  KGKtvSdk
//
//  Created by deng on 16/4/7.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVModalViewController.h"
#import "KTVModalView.h"

@interface KTVModalViewController ()

@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *hasBackground;
@property (weak, nonatomic) IBOutlet UISwitch *hasBlur;
@property (weak, nonatomic) IBOutlet UISlider *backgroundAlpha;
@property (weak, nonatomic) IBOutlet UISwitch *shake;
@property (nonatomic, strong) KTVModalView *modalView;

@end

@implementation KTVModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showAction:(id)sender {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    customView.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Test";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:30];
    label.frame = customView.bounds;
    [customView addSubview:label];

    KTVModalView *modalView = [[KTVModalView alloc] initWithCustomView:customView fromView:self.showButton];
    [modalView presentModelViewContainerView:self.tabBarController.view animation:YES completion:^{
        NSLog(@"completion");
    }];
    self.modalView = modalView;
}
- (IBAction)hasBackground:(UISwitch *)sender {
    self.hasBlur.enabled = sender.on;
    self.backgroundAlpha.enabled = sender.on && !self.hasBlur.on;
}
- (IBAction)hasBur:(UISwitch *)sender {
    self.backgroundAlpha.enabled = self.hasBackground.on && !sender.on;
}

@end
