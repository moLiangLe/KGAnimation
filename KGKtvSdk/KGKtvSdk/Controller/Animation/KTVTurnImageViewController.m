//
//  KTVTurnImageViewController.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/25.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVTurnImageViewController.h"
#import "KTVTurnImageView.h"

@interface KTVTurnImageViewController ()

@property (weak, nonatomic) IBOutlet KTVTurnImageView *imageView;

@end

@implementation KTVTurnImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView.nornalImage = [UIImage imageNamed:@"hehe"];
    _imageView.turnImage = [UIImage imageNamed:@"guoqi"];
}

- (IBAction)turn:(id)sender {
    [self.imageView turnWithAnimated:YES];
}

@end
