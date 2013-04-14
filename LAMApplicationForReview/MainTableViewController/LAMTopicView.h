//
//  LAMTopicView.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 14.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LAMTopicView : UIView

@property (nonatomic, strong) NSString *title;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
- (void)setSelected:(BOOL)isSelected;

@end
