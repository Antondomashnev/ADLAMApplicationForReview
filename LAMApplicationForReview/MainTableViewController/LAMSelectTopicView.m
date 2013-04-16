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

#define TOPIC_VIEW_SIZE CGSizeMake(320, 44)

@interface LAMSelectTopicView()

@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, strong) NSMutableArray *topicsViewArray;
@property (nonatomic, strong) LAMTopicView *selectedTopicView;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, unsafe_unretained) BOOL wasExpanded;
@property (nonatomic, unsafe_unretained) BOOL shouldContractOnTouchesEnded;

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

- (id)initWithTopicsArray:(NSArray *)topics{
    
    if(self = [super initWithFrame: [LAMSelectTopicView contractedRect]]){
        
        self.topics = [topics mutableCopy];
        self.topicsViewArray = [NSMutableArray array];
        self.selectedTopic = ([topics count] > 0) ? topics[0] : nil;
        self.shouldContractOnTouchesEnded = NO;
        
        [self.topics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            [self.topicsViewArray addObject: [self addTopicViewWithTitle:obj atIndex:idx]];
        }];
        
        for(int i = 0; i < [self.topics count] - 1; i++){
            
            [self addSeparatorViewAtIndex: i];
        }

        self.clipsToBounds = YES;
        
        self.selectedTopicView = ([self.topicsViewArray count] > 0) ? self.topicsViewArray[0] : nil;
        [self updateTopicViewsTitleAccordingSelectedTopicView];
        [self addArrowImageView];
    }
    
    return self;
}

#pragma mark Frames

+ (CGRect)contractedRect{
    
    return CGRectMake(0, 0, TOPIC_VIEW_SIZE.width, TOPIC_VIEW_SIZE.height);
}

+ (CGRect)expandedRectForLAMSelectTopicViewWithTopics:(NSArray *)topics{
    
    CGRect expandRect = [LAMSelectTopicView contractedRect];
    expandRect.size.height = [topics count] * TOPIC_VIEW_SIZE.height;
    
    return expandRect;
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
    
    if(!self.wasExpanded &&
       self.delegate &&
       [self.delegate respondsToSelector:@selector(LAMSelectTopicViewWillExpand:)]){
        
        [self.delegate LAMSelectTopicViewWillExpand: self];
    }
    
    [self animateToNewRect: [LAMSelectTopicView expandedRectForLAMSelectTopicViewWithTopics: self.topics]];
    self.layer.cornerRadius = 2.f;
    
    [self rotateArrowFor: 180.];
    
    self.wasExpanded = YES;
}

#pragma mark Contract

- (void)contract{
    
    if(self.wasExpanded && 
       self.delegate &&
       [self.delegate respondsToSelector:@selector(LAMSelectTopicViewWillContract:)]){
        
        [self.delegate LAMSelectTopicViewWillContract: self];
    }
    
    [self animateToNewRect: [LAMSelectTopicView contractedRect]];
    self.layer.cornerRadius = 0.f;
    
    [self rotateArrowFor: 0.];
    
    [self deselectSelectedTopicView];
    
    self.wasExpanded = NO;
    self.shouldContractOnTouchesEnded = NO;
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
    
    self.shouldContractOnTouchesEnded = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self userDidEndTouches:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self userDidEndTouches:touches withEvent:event];
}

- (void)userDidEndTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(self.shouldContractOnTouchesEnded){
        
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
    else{
        
        self.shouldContractOnTouchesEnded = YES;
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
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, (index + 1) * (TOPIC_VIEW_SIZE.height) - SEPARATOR_VIEW_HEIGHT, TOPIC_VIEW_SIZE.width, SEPARATOR_VIEW_HEIGHT)];
    [separatorView setBackgroundColor: [UIColor LAMSelectTopicViewSeparatorColor]];
    [self addSubview: separatorView];
}

- (LAMTopicView *)addTopicViewWithTitle:(NSString *)topic atIndex:(NSUInteger)viewIndex{
    
    CGFloat originY = (TOPIC_VIEW_SIZE.height) * viewIndex;
    LAMTopicView *view = [[LAMTopicView alloc] initWithFrame:CGRectMake(0, originY, TOPIC_VIEW_SIZE.width, TOPIC_VIEW_SIZE.height)
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
