//
//  LAMPost.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "LAMPost.h"

@implementation LAMPost

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if([key isEqualToString:@"image_featured"]){
        
        [super setValue:[NSURL URLWithString:value] forKey:@"featuredImageURL"];
    }
    else if([key isEqualToString:@"body_preamble"]){
        
        [super setValue:value forKey:@"bodyPreamble"];
    }
    else{
        
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"LAMPost setValue:%@ forUndefinedKey:%@", value, key);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"title:%@ \nflow:%@ \nbodyPreamble:%@ \nfeaturedImageURL:%@", self.title, self.flow, self.bodyPreamble, self.featuredImageURL];
}

+ (NSString *)localizedTopic:(NSString *)englishTopic{
    if([englishTopic isEqualToString:@"media"]){
        return NSLocalizedString(@"Медиа", @"");
    }
    else if([englishTopic isEqualToString:@"film"]){
        return NSLocalizedString(@"Кино и ТВ", @"");
    }
    else if([englishTopic isEqualToString:@"fashion"]){
        return NSLocalizedString(@"Мода", @"");
    }
    else if([englishTopic isEqualToString:@"music"]){
        return NSLocalizedString(@"Музыка", @"");
    }
    
    return @"";
}

@end
