//
//  KTVCircleProgressViewController.m
//  KGKtvSdk
//
//  Created by Dng on 16/4/25.
//  Copyright © 2016年 dng. All rights reserved.
//

#import "KTVCircleProgressViewController.h"
#import "KTVCircleProgressView.h"

@interface KTVCircleProgressViewController ()

@property (nonatomic, strong) KTVCircleProgressView *circleProgressView;
@property (nonatomic, strong) IBOutlet UISlider *colorR;
@property (nonatomic, strong) IBOutlet UISlider *colorG;
@property (nonatomic, strong) IBOutlet UISlider *colorB;
@property (nonatomic, strong) IBOutlet UISlider *colorA;

@end

@implementation KTVCircleProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.circleProgressView = [[KTVCircleProgressView alloc] initWithFrame:CGRectMake(0.f, 100.f, 100.f, 100.f)];
    self.circleProgressView.center = CGPointMake(self.view.center.x, self.circleProgressView.center.y);
    self.circleProgressView.strokeColor = [UIColor blackColor];
    [self.circleProgressView setStrokeEnd:0.6f animated:NO];
    [self.view addSubview:self.circleProgressView];
}

- (IBAction)start:(UISlider *)sender {
    [self.circleProgressView setStrokeStart:sender.value animated:YES];
}

- (IBAction)end:(UISlider *)sender {
    [self.circleProgressView setStrokeEnd:sender.value animated:YES];
}

- (IBAction)ColorR:(UISlider *)sender {
    [self.circleProgressView setStrokeColor:[UIColor colorWithRed:sender.value green:self.colorG.value blue:self.colorB.value alpha:self.colorA.value] animated:YES];
}

- (IBAction)ColorG:(UISlider *)sender {
    [self.circleProgressView setStrokeColor:[UIColor colorWithRed:self.colorR.value green:sender.value blue:self.colorB.value alpha:self.colorA.value] animated:YES];
}

- (IBAction)ColorB:(UISlider *)sender {
    [self.circleProgressView setStrokeColor:[UIColor colorWithRed:self.colorR.value green:self.colorG.value blue:sender.value alpha:self.colorA.value] animated:YES];
}

- (IBAction)ColorA:(UISlider *)sender {
    [self.circleProgressView setStrokeColor:[UIColor colorWithRed:self.colorR.value green:self.colorG.value blue:self.colorB.value alpha:sender.value] animated:YES];
}

- (IBAction)Width:(UISlider *)sender {
    [self.circleProgressView setStrokeLineWidth:(sender.value * self.circleProgressView.frame.size.width) animated:YES];
}

- (IBAction)cap:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.circleProgressView setStrokeLineCap:kCALineCapButt];
    } else if (sender.selectedSegmentIndex == 1) {
        [self.circleProgressView setStrokeLineCap:kCALineCapRound];
    } else {
        [self.circleProgressView setStrokeLineCap:kCALineCapSquare];
    }
}

- (IBAction)join:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.circleProgressView setStrokeLineJoin:kCALineJoinMiter];
    } else if (sender.selectedSegmentIndex == 1) {
        [self.circleProgressView setStrokeLineJoin:kCALineJoinRound];
    } else {
        [self.circleProgressView setStrokeLineJoin:kCALineJoinBevel];
    }
}

@end
