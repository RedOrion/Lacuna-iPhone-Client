//
//  LEBuildingAcceptTrade.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingAcceptTrade : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *tradeId;
@property (nonatomic, retain) NSString *tradeShipId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl tradeId:(NSString *)tradeId tradeShipId:(NSString *)tradeShipId;


@end
