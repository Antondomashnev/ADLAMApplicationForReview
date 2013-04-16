//
//  LAMSelectTopicView.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 14.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LAMSelectTopicView;

@protocol LAMSelectTopicViewDelegate <NSObject>

- (void)LAMSelectTopicView:(LAMSelectTopicView *)view didSelectTopic:(NSString *)topic;
- (void)LAMSelectTopicViewWillExpand:(LAMSelectTopicView *)view;
- (void)LAMSelectTopicViewWillContract:(LAMSelectTopicView *)view;

@end

@interface LAMSelectTopicView : UIView

@property (nonatomic, weak) id<LAMSelectTopicViewDelegate> delegate;
@property (nonatomic, strong) NSString *selectedTopic;

- (id)initWithTopicsArray:(NSArray *)topics;

- (void)contract;

@end
