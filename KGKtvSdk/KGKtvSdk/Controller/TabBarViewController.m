//
//  TabBarViewController.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/7.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage * image1 = [[UIImage imageNamed:@"gtx"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * image2 = [[UIImage imageNamed:@"ljr"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSArray *images = @[image1, image2];
    NSArray *titles = @[@"动画", @"性能"];
    
    for (NSInteger i = 0; i < self.viewControllers.count; i++) {
        UINavigationController *nav = self.viewControllers[i];
        nav.tabBarItem=[[UITabBarItem alloc] initWithTitle:titles[i] image:images[i] selectedImage:images[i]];
        if (i == 0) {
            [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:182 / 255.0 green:5 / 255.0 blue:39 / 255.0 alpha:1.000]} forState:UIControlStateNormal];
        } else {
            [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1 / 255.0 green:161 / 255.0 blue:65 / 255.0 alpha:1.000]} forState:UIControlStateNormal];
        }
    }
    
}

@end
