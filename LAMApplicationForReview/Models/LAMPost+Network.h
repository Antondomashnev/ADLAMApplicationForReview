//
//  LAMPost+Network.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "LAMPost.h"

@interface LAMPost (Network)

+ (NSArray *)loadedTopicsArray;
+ (void)loadPostsWithCallback:(LAMArrayResultBlock)callback;

@end
