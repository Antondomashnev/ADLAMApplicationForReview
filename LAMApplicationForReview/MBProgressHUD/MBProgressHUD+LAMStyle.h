//
//  MBProgressHUD+LAMStyle.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LAMStyle)

+ (MBProgressHUD *)showErrorHUDAddedTo:(UIView *)view withError:(NSError *)error animated:(BOOL)animated;
+ (MBProgressHUD *)showLoadingHUDAddedTo:(UIView *)view animated:(BOOL)animated;

@end
