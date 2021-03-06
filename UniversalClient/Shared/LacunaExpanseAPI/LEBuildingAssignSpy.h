//
//  LEBuildingAssignSpy.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingAssignSpy : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *spyId;
	NSString *assignment;
	NSMutableDictionary *mission;
	NSMutableDictionary *spyData;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSString *spyId;
@property(nonatomic, retain) NSString *assignment;
@property(nonatomic, retain) NSMutableDictionary *mission;
@property(nonatomic, retain) NSMutableDictionary *spyData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl spyId:(NSString *)spyId assignment:(NSString *)assignment;


@end
