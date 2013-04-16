//
//  LAMDimView.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 17.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "LAMDimView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+LAMStyle.h"

#define LAM_DIM_VIEW_SHOW_AND_HIDE_ANIMATION_DURATION .3
#define LAM_DIM_VIEW_TAG 10101010

@implementation LAMDimView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addGradientLayer];
    }
    return self;
}

- (void)addGradientLayer{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = @[(id)[[UIColor LAMDimViewTopGradientColor] CGColor], (id)[[UIColor LAMDimViewBottomGradientColor] CGColor]];
    gradient.startPoint = CGPointMake(.0, 0.5);
    gradient.endPoint = CGPointMake(0., 1.);
    [self.layer addSublayer: gradient];
}

+ (LAMDimView *)showInView:(UIView *)view animated:(BOOL)animated{
    
    LAMDimView *dimView = [[LAMDimView alloc] initWithFrame: view.bounds];
    dimView.tag = LAM_DIM_VIEW_TAG;
    dimView.alpha = 0.f;
    
    [view addSubview: dimView];
    
    [UIView animateWithDuration:(animated) ? LAM_DIM_VIEW_SHOW_AND_HIDE_ANIMATION_DURATION : 0. animations:^{
        
        dimView.alpha = 1.f;
    }];
    
    return dimView;
}

+ (void)hideFromView:(UIView *)view animated:(BOOL)animated{
    
    LAMDimView *dimView = (LAMDimView *)[view viewWithTag: LAM_DIM_VIEW_TAG];
    
    [UIView animateWithDuration:(animated) ? LAM_DIM_VIEW_SHOW_AND_HIDE_ANIMATION_DURATION : 0. animations:^{
        
        dimView.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        [dimView removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
