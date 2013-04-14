//
//  LAMPostCell.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "LAMPostCell.h"
#import "UIFont+LAMStyle.h"
#import "LAMPost.h"
#import "UIColor+LAMStyle.h"
#import "UIImageView+WebCache.h"

#define POST_CELL_CONTENT_BOTTOM_MARGIN 15
#define POST_CELL_MARGIN_BETWEEN_LABELS 6
#define POST_CELL_LABEL_RIGHT_MARGIN 14

#define POST_CELL_LABEL_WIDTH 292

#define POST_IMAGE_VIEW_RECT CGRectMake(5, 5, 310, 200)

@interface LAMPostCell()

@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UILabel *postTitleLabel;
@property (nonatomic, strong) UILabel *postFlowLabel;
@property (nonatomic, strong) UILabel *postBodyPreambleLabel;

@end

@implementation LAMPostCell

@synthesize associatedPost = _associatedPost;

#pragma mark Alpha

- (void)updateAlphaForOffsetYFromScreenCenter:(CGFloat)offsetY{
 
    //NSLog(@"OFFSET %f", offsetY);
    
    if(offsetY > LAM_POST_CELL_ZERO_ALPHA_CENTER_OFFSET_Y){
        self.alpha = 0.f;
    }
    else{
        self.alpha = 1 - (offsetY / LAM_POST_CELL_ZERO_ALPHA_CENTER_OFFSET_Y);
    }
}

#pragma mark Height

+ (CGFloat)heightForCellWithAssociatedPost:(LAMPost *)associatedPost{
    
    CGFloat height = POST_IMAGE_VIEW_RECT.origin.y + POST_IMAGE_VIEW_RECT.size.height;
    
    //Plus height of flow label
    height += POST_CELL_MARGIN_BETWEEN_LABELS;
    height += [associatedPost.flow sizeWithFont:[UIFont LAMDefaultBoldFontWithSize:12.] constrainedToSize:CGSizeMake(POST_CELL_LABEL_WIDTH, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    //Plus height of title label
    height += POST_CELL_MARGIN_BETWEEN_LABELS;
    height += [associatedPost.title sizeWithFont:[UIFont LAMDefaultBoldFontWithSize:14.] constrainedToSize:CGSizeMake(POST_CELL_LABEL_WIDTH, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    //Plus height of body preamble label
    height += POST_CELL_MARGIN_BETWEEN_LABELS;
    height += [associatedPost.bodyPreamble sizeWithFont:[UIFont LAMDefaultRegularFontWithSize:12.] constrainedToSize:CGSizeMake(POST_CELL_LABEL_WIDTH, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    //Plust bottom margin
    height += POST_CELL_CONTENT_BOTTOM_MARGIN;
    
    return height;
}

#pragma mark Reposition

- (void)repositionCellContentViewsForAssociatedLamPost:(LAMPost *)post{
    
    CGRect flowLabelRect = CGRectZero;
    flowLabelRect.origin.x = POST_CELL_LABEL_RIGHT_MARGIN;
    flowLabelRect.origin.y = POST_IMAGE_VIEW_RECT.origin.y + POST_IMAGE_VIEW_RECT.size.height + POST_CELL_MARGIN_BETWEEN_LABELS;
    flowLabelRect.size.width = POST_CELL_LABEL_WIDTH;
    flowLabelRect.size.height = [post.flow sizeWithFont:[UIFont LAMDefaultBoldFontWithSize:12.] constrainedToSize:CGSizeMake(POST_CELL_LABEL_WIDTH, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    self.postFlowLabel.frame = flowLabelRect;
    
    CGRect titleLabelRect = CGRectZero;
    titleLabelRect.origin.x = POST_CELL_LABEL_RIGHT_MARGIN;
    titleLabelRect.origin.y = flowLabelRect.origin.y + flowLabelRect.size.height + POST_CELL_MARGIN_BETWEEN_LABELS;
    titleLabelRect.size.width = POST_CELL_LABEL_WIDTH;
    titleLabelRect.size.height = [post.title sizeWithFont:[UIFont LAMDefaultBoldFontWithSize:14.] constrainedToSize:CGSizeMake(POST_CELL_LABEL_WIDTH, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    self.postTitleLabel.frame = titleLabelRect;
    
    CGRect bodyPreambleLabelRect = CGRectZero;
    bodyPreambleLabelRect.origin.x = POST_CELL_LABEL_RIGHT_MARGIN;
    bodyPreambleLabelRect.origin.y = titleLabelRect.origin.y + titleLabelRect.size.height + POST_CELL_MARGIN_BETWEEN_LABELS;
    bodyPreambleLabelRect.size.width = POST_CELL_LABEL_WIDTH;
    bodyPreambleLabelRect.size.height = [post.bodyPreamble sizeWithFont:[UIFont LAMDefaultRegularFontWithSize:12.] constrainedToSize:CGSizeMake(POST_CELL_LABEL_WIDTH, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    self.postBodyPreambleLabel.frame = bodyPreambleLabelRect;
}

#pragma mark AssociatedPost

- (void)setAssociatedPost:(LAMPost *)associatedPost{
    
    _associatedPost = associatedPost;
    
    [self.postImageView setImageWithURL:associatedPost.featuredImageURL];
    [self.postFlowLabel setText:associatedPost.flow];
    [self.postTitleLabel setText:associatedPost.title];
    [self.postBodyPreambleLabel setText:associatedPost.bodyPreamble];
    
    [self repositionCellContentViewsForAssociatedLamPost: associatedPost];
}

#pragma mark PostImageView

- (void)addPostImageView{
    
    self.postImageView = [[UIImageView alloc] initWithFrame:POST_IMAGE_VIEW_RECT];
    self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.postImageView.clipsToBounds = YES;
    [self addSubview: self.postImageView];
}

#pragma mark PostTitleLabel

- (void)addPostTitleLabel{
    
    self.postTitleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.postTitleLabel.backgroundColor = [UIColor clearColor];
    self.postTitleLabel.numberOfLines = 0;
    self.postTitleLabel.font = [UIFont LAMDefaultBoldFontWithSize:14.];
    self.postTitleLabel.textColor = [UIColor LAMPostCellTitleColor];
    [self addSubview: self.postTitleLabel];
}

#pragma mark PostFlowLabel

- (void)addPostFlowLabel{
    
    self.postFlowLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.postFlowLabel.backgroundColor = [UIColor clearColor];
    self.postFlowLabel.numberOfLines = 0;
    self.postFlowLabel.font = [UIFont LAMDefaultBoldFontWithSize:12.];
    self.postFlowLabel.textColor = [UIColor LAMPostCellFlowColor];
    [self addSubview: self.postFlowLabel];
}

#pragma mark PostBodyPreambleLabel

- (void)addPostBodyPreambleLabel{
    
    self.postBodyPreambleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.postBodyPreambleLabel.backgroundColor = [UIColor clearColor];
    self.postBodyPreambleLabel.numberOfLines = 0;
    self.postBodyPreambleLabel.font = [UIFont LAMDefaultRegularFontWithSize:12.];
    self.postBodyPreambleLabel.textColor = [UIColor LAMPostCellBodyPreambleColor];
    [self addSubview: self.postBodyPreambleLabel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addPostBodyPreambleLabel];
        [self addPostFlowLabel];
        [self addPostImageView];
        [self addPostTitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
