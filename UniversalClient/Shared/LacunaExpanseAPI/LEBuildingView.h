//
//  LEGetBuilding.h
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingView : LERequest {
	NSString *buildingId;
	NSMutableDictionary *result;
	NSString *buildingUrl;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSMutableDictionary *result;
@property(nonatomic, retain) NSString *buildingUrl;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId url:(NSString *)buildingUrl;


@end
