//
//  LAMSelectTopicView.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 14.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "LAMSelectTopicView.h"
#import "LAMTopicView.h"
#import "UIColor+LAMStyle.h"
#import <QuartzCore/QuartzCore.h>

#define EXPAND_ANIMATION_DURATION .3f

#define SEPARATOR_VIEW_HEIGHT 1

#define ARROW_IMAGE_VIEW_FRAME CGRectMake(295, 20, 10, 6)

@interface LAMSelectTopicView()

@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, unsafe_unretained) CGSize topicViewSize;

@property (nonatomic, strong) NSMutableArray *topicsViewArray;
@property (nonatomic, strong) LAMTopicView *selectedTopicView;

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation LAMSelectTopicView

@synthesize topics = _topics;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTopicsArray:(NSArray *)topics inNavigationBar:(UINavigationBar *)navigationBar{
    
    if(self = [super initWithFrame: navigationBar.bounds]){
        
        self.topics = [topics mutableCopy];
        self.topicsViewArray = [NSMutableArray array];
        self.topicViewSize  = navigationBar.bounds.size;
        self.selectedTopic = ([topics count] > 0) ? topics[0] : nil;
        
        [self.topics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            [self.topicsViewArray addObject: [self addTopicViewWithTitle:obj atIndex:idx]];
        }];
        
        for(int i = 0; i < [self.topics count] - 1; i++){
            
            [self addSeparatorViewAtIndex: i];
        }
        
        [navigationBar addSubview: self];
        self.clipsToBounds = YES;
        
        self.selectedTopicView = ([self.topicsViewArray count] > 0) ? self.topicsViewArray[0] : nil;
        [self updateTopicViewsTitleAccordingSelectedTopicView];
        
        [self addArrowImageView];
    }
    
    return self;
}

#pragma mark Arrow

- (void)addArrowImageView{
    
    self.arrowImageView = [[UIImageView alloc] initWithFrame:ARROW_IMAGE_VIEW_FRAME];
    self.arrowImageView.image = [UIImage imageNamed:@"arrow_down.png"];
    [self addSubview: self.arrowImageView];
}

#pragma mark Animation

- (void)rotateArrowFor:(float)degrees{
    
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:EXPAND_ANIMATION_DURATION];
    self.arrowImageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    [UIView commitAnimations];
}

- (void)animateToNewRect:(CGRect)newRect{
    
    [UIView animateWithDuration:EXPAND_ANIMATION_DURATION animations:^{
        
        self.frame = newRect;
    }];
}

#pragma mark Expand

- (void)expand{
    
    CGRect expandRect = self.frame;
    expandRect.size.height = [self.topics count] * self.topicViewSize.height;
    
    [self animateToNewRect: expandRect];
    self.layer.cornerRadius = 2.f;
    
    [self rotateArrowFor: 180.];
}

#pragma mark Contract

- (void)contract{
    
    CGRect contractRect = self.frame;
    contractRect.size.height = self.topicViewSize.height;
    
    [self animateToNewRect: contractRect];
    self.layer.cornerRadius = 0.f;
    
    [self rotateArrowFor: 0.];
    
    [self deselectSelectedTopicView];
}

#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    UIView* topicView = [self hitTest:locationPoint withEvent:event];
    if([topicView isKindOfClass: [LAMTopicView class]]){
        
        self.selectedTopicView = (LAMTopicView *)topicView;
        [self.selectedTopicView setSelected: YES];
        [self expand];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    UIView* topicView = [self hitTest:locationPoint withEvent:event];
    if([topicView isKindOfClass: [LAMTopicView class]] &&
       ![topicView isEqual: self.selectedTopicView]){
        
        [self.selectedTopicView setSelected: NO];
        self.selectedTopicView = (LAMTopicView *)topicView;
        [self.selectedTopicView setSelected: YES];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self userDidEndTouches:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self userDidEndTouches:touches withEvent:event];
}

- (void)userDidEndTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    UIView* topicView = [self hitTest:locationPoint withEvent:event];
    if([topicView isKindOfClass: [LAMTopicView class]]){
        
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(LAMSelectTopicView:didSelectTopic:)]){
            
            self.selectedTopic = self.selectedTopicView.title;
            [self.delegate LAMSelectTopicView:self didSelectTopic: self.selectedTopic];
        }
        
        [self updateTopicViewsTitleAccordingSelectedTopicView];
        [self deselectSelectedTopicView];
        [self contract];
    }
    else{
        
        [self contract];
    }
}

#pragma mark DeselectTopic

- (void)deselectSelectedTopicView{
    
    [self.selectedTopicView setSelected: NO];
    [self setSelectedTopic: nil];
}

#pragma mark TopicViewTitle

- (void)updateTopicViewsTitleAccordingSelectedTopicView{
    
    NSUInteger selectedTopicViewIndex = [self.topicsViewArray indexOfObject: self.selectedTopicView];
    [self.topics exchangeObjectAtIndex:0 withObjectAtIndex:selectedTopicViewIndex];
    [self.topics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [(LAMTopicView *)self.topicsViewArray[idx] setTitle: obj];
    }];
}

#pragma mark TopicView

- (void)addSeparatorViewAtIndex:(NSUInteger)index{
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, (index + 1) * (self.topicViewSize.height) - SEPARATOR_VIEW_HEIGHT, self.topicViewSize.width, SEPARATOR_VIEW_HEIGHT)];
    [separatorView setBackgroundColor: [UIColor LAMSelectTopicViewSeparatorColor]];
    [self addSubview: separatorView];
}

- (LAMTopicView *)addTopicViewWithTitle:(NSString *)topic atIndex:(NSUInteger)viewIndex{
    
    CGFloat originY = (self.topicViewSize.height) * viewIndex;
    LAMTopicView *view = [[LAMTopicView alloc] initWithFrame:CGRectMake(0, originY, self.topicViewSize.width, self.topicViewSize.height)
                                                    andTitle:topic];
    
    [self addSubview: view];
    
    return view;
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
