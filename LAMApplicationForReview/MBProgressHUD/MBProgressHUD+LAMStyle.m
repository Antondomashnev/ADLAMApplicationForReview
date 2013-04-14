//
//  MBProgressHUD+LAMStyle.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "MBProgressHUD+LAMStyle.h"

@implementation MBProgressHUD (LAMStyle)

+ (MBProgressHUD *)showErrorHUDAddedTo:(UIView *)view withError:(NSError *)error animated:(BOOL)animated{
    
    return nil;
}

+ (MBProgressHUD *)showLoadingHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.labelText = NSLocalizedString(@"Loading", @"");
    hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

@end
