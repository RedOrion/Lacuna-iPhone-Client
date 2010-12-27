//
//  LEBuildingRunExperiment.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingRunExperiment.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildingRunExperiment


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize spyId;
@synthesize affinity;
@synthesize graftSucceeded;
@synthesize spySurvived;
@synthesize message;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl spyId:(NSString *)inSpyId affinity:(NSString *)inAffinity {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.spyId = inSpyId;
	self.affinity = inAffinity;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.buildingId, self.spyId, self.affinity);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSDictionary *experiment = [result objectForKey:@"experiment"];
	NSLog(@"Experiment Data: %@", experiment);
	self.graftSucceeded = [[experiment objectForKey:@"graft"] boolValue];
	self.spySurvived = [[experiment objectForKey:@"survive"] boolValue];
	self.message = [experiment objectForKey:@"message"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_star";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.spyId = nil;
	self.affinity = nil;
	self.spyId = nil;
	[super dealloc];
}



@end