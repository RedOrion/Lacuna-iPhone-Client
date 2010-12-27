//
//  LEBuildingPrepareExperiment.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingPrepareExperiment : LERequest {
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSMutableArray *grafts;
@property(nonatomic, retain) NSDecimalNumber *survivalOdds;
@property(nonatomic, retain) NSDecimalNumber *graftOdds;
@property(nonatomic, retain) NSDecimalNumber *essentiaCost;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end