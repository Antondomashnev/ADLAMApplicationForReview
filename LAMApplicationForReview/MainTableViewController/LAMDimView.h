//
//  LAMDimView.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 17.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LAMDimView : UIView

+ (LAMDimView *)showInView:(UIView *)view animated:(BOOL)animated;
+ (void)hideFromView:(UIView *)view animated:(BOOL)animated;

@end
