//
//  LAMPost+Network.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "LAMPost+Network.h"
#import "AFHTTPClient.h"

@implementation LAMPost (Network)

+ (NSArray *)loadedTopicsArray{
    
    return @[@"fashion", @"music", @"film", @"media"];
}

+ (NSArray *)postsArrayFromJSONData:(id)JSONData{
    
    NSArray *loadedTopics = [LAMPost loadedTopicsArray];
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
    
    if(!error){
        
        NSMutableArray *postsArray = [NSMutableArray array];
        for(NSDictionary *postDict in jsonDict[@"items"]){
            
            NSString *postJSONTopic = postDict[@"url_params"][@"topic"];
            BOOL isNeededTopic = [[loadedTopics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", postJSONTopic]] count] > 0;
            
            if(isNeededTopic){
            
                LAMPost *post = [[LAMPost alloc] init];
                [post setValuesForKeysWithDictionary: postDict];
                [post setTopic: postJSONTopic];
                [postsArray addObject: post];
            }
        }
        
        return postsArray;
    }
    else{
        
        NSLog(@"Error: failed to parse JSON %@", error.description);
        return nil;
    }
}

+ (void)loadPostsWithCallback:(LAMArrayResultBlock)callback{
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL: [NSURL URLWithString:LAMServerURL]];
    [client getPath:@"index.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *postsArray = [LAMPost postsArrayFromJSONData: responseObject];
        if(postsArray){
            callback(postsArray, nil);
        }
        else{
            NSError *error = [NSError errorWithDomain:LAMServerErrorDomain code:LAMServerErrorCodeParseJSON userInfo:nil];
            callback(nil, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error %@", error.description);
    }];
}

@end
