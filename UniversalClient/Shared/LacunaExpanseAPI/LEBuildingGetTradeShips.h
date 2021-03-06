//
//  LEBuildingGetTradeShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetTradeShips : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *targetBodyId;
@property (nonatomic, retain) NSMutableArray *ships;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl targetBodyId:(NSString *)targetBodyId;


@end
