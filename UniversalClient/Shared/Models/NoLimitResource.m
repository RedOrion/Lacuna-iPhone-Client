//
//  NoLimitResource.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NoLimitResource.h"
#import "LEMacros.h"


@interface NoLimitResource (PrivateMethods)

- (NSNumber *)getAsNSNumber:(id)object;

@end


@implementation NoLimitResource


@synthesize current;
@synthesize perHour;
@synthesize perSec;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ current:%@, perHour:%i, perSec:%@ }",
			self.current, self.perHour, self.perSec];
}


- (void)dealloc {
	self.current = nil;
	self.perSec = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)tick:(NSInteger)interval {
	double tmp = ([self.current doubleValue] + ([self.perSec doubleValue] * interval));
	self.current = [NSNumber numberWithDouble:tmp];
}


- (void)addToCurrent:(NSNumber *)adjustment {
	double tmp = ([self.current doubleValue] + [adjustment doubleValue]);
	self.current = [NSNumber numberWithDouble:tmp];
}

				  
- (void)subtractFromCurrent:(NSNumber *)adjustment {
	double tmp = ([self.current doubleValue] - [adjustment doubleValue]);
	self.current = [NSNumber numberWithDouble:tmp];
}


- (void)parseFromData:(NSDictionary *)data withPrefix:(NSString *)prefix{
	
	self.current = [self getAsNSNumber:[data objectForKey:[NSString stringWithFormat:@"%@", prefix]]];
	self.perHour = [[self getAsNSNumber:[data objectForKey:[NSString stringWithFormat:@"%@_hour", prefix]]] intValue];
	self.perSec = [NSNumber numberWithFloat:self.perHour / SEC_IN_HOUR];
}


#pragma mark --
#pragma mark PrivateMethods

- (NSNumber *)getAsNSNumber:(id)object {
	NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	if ([object isKindOfClass:[NSString class]]) {
		return [f numberFromString:object];
	} else if ([object isKindOfClass:[NSNumber class]]) {
		return object;
	} else {
		NSLog(@"WTF HOW DO I HANDLE THIS: %@", object);
		return nil;
	}
}


@end
