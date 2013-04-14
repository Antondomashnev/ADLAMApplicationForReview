//
//  LAMConstants.h
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

typedef enum{
    LAMServerErrorCodeParseJSON = 100
}LAMServerErrorCode;

extern NSString* const LAMServerURL;
extern NSString* const LAMServerErrorDomain;

typedef void (^LAMArrayResultBlock)(NSArray *objects, NSError *error);

//LAMPostCellAlphaFormulaConstants
#define LAM_POST_CELL_ZERO_ALPHA_CENTER_OFFSET_Y 400


