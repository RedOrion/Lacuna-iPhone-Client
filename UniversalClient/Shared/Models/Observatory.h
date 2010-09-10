//
//  Observatory.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Observatory : Building {
	NSMutableArray *probedStars;
	NSInteger probedStarsPageNumber;
	NSDecimalNumber *numProbedStars;
}


@property (nonatomic, retain) NSMutableArray *probedStars;
@property (nonatomic, assign) NSInteger probedStarsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numProbedStars;


- (void)loadProbedStarsForPage:(NSInteger)pageNumber;
- (void)abandonProbeAtStar:(NSString *)starId;
- (bool)hasPreviousProbedStarsPage;
- (bool)hasNextProbedStarsPage;


@end
