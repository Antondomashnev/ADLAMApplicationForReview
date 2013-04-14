//
//  LAMTopicView.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 14.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "LAMTopicView.h"
#import "UIColor+LAMStyle.h"
#import "UIFont+LAMStyle.h"
#import "LAMPost.h"

#define TITLE_LABEL_FRAME CGRectMake(15, 14, 290, 18)

@interface LAMTopicView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LAMTopicView

@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = title;
        self.backgroundColor = [UIColor LAMTopicViewNormalColor];
        [self addTitleLabelWithTitle: title];
    }
    return self;
}

#pragma mark Title

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    self.titleLabel.text = [LAMPost localizedTopic: title];
}

#pragma mark TitleLabel

- (void)addTitleLabelWithTitle:(NSString *)title{
    
    self.titleLabel = [[UILabel alloc] initWithFrame: TITLE_LABEL_FRAME];
    self.titleLabel.text = [LAMPost localizedTopic: title];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor LAMTopicViewTitleColor];
    self.titleLabel.font = [UIFont LAMDefaultBoldFontWithSize: 16.f];
    
    [self addSubview: self.titleLabel];
}

#pragma mark Selected

- (void)setSelected:(BOOL)isSelected{
    
    self.backgroundColor = (isSelected) ? [UIColor LAMTopicViewSelectedColor] : [UIColor LAMTopicViewNormalColor];
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
