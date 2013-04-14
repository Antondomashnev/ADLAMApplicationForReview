//
//  LAMPostCell.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LAMPost;

@interface LAMPostCell : UITableViewCell

+ (CGFloat)heightForCellWithAssociatedPost:(LAMPost *)associatedPost;

- (void)updateAlphaForOffsetYFromScreenCenter:(CGFloat)offsetY;

@property (nonatomic, strong) LAMPost *associatedPost;

@end
