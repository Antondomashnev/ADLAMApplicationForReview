//
//  UIFont+LAMStyle.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "UIFont+LAMStyle.h"

@implementation UIFont (LAMStyle)

+ (UIFont *)LAMDefaultBoldFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+ (UIFont *)LAMDefaultRegularFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

@end
