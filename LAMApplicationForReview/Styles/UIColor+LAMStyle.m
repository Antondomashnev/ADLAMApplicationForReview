//
//  UIColor+LAMStyle.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "UIColor+LAMStyle.h"

@implementation UIColor (LAMStyle)

+ (UIColor *)LAMPostCellTitleColor{
    return [UIColor blackColor];
}

+ (UIColor *)LAMPostCellFlowColor{
    return [UIColor blackColor];
}

+ (UIColor *)LAMPostCellBodyPreambleColor{
    return [UIColor colorWithRed:125./255. green:125./255. blue:125./255. alpha:1.f];
}

+ (UIColor *)LAMTopicViewNormalColor{
    return [UIColor colorWithRed:78./255. green:83./255. blue:84./255. alpha:1.f];
}

+ (UIColor *)LAMTopicViewSelectedColor{
    return [UIColor colorWithRed:59./255 green:62./255. blue:63./255. alpha:1.f];
}

+ (UIColor *)LAMTopicViewTitleColor{
    return [UIColor whiteColor];
}

+ (UIColor *)LAMSelectTopicViewSeparatorColor{
    return [UIColor blackColor];
}

@end
