//
//  LEEmpireViewBoosts.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireViewBoosts.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireViewBoosts


@synthesize boosts;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	self.boosts = nil;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return array_(session.sessionId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSDictionary *tmp = [result objectForKey:@"boosts"];
	NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithCapacity:5];

	[newDict setObject:[Util date:[tmp objectForKey:@"energy"]] forKey:@"energy"];
	[newDict setObject:[Util date:[tmp objectForKey:@"food"]] forKey:@"food"];
	[newDict setObject:[Util date:[tmp objectForKey:@"happiness"]] forKey:@"happiness"];
	[newDict setObject:[Util date:[tmp objectForKey:@"ore"]] forKey:@"ore"];
	[newDict setObject:[Util date:[tmp objectForKey:@"water"]] forKey:@"water"];
	
	self.boosts = newDict;
	NSLog(@"Boosts: %@", self.boosts);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"view_boosts";
}


- (void)dealloc {
	self.boosts = nil;
	[super dealloc];
}


@end