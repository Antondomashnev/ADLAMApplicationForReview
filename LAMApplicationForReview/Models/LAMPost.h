//
//  LAMPost.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAMPost : NSObject

@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *flow;
@property (nonatomic, strong) NSString *bodyPreamble;
@property (nonatomic, strong) NSURL *featuredImageURL;

+ (NSString *)localizedTopic:(NSString *)englishTopic;

@end
