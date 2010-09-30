//
//  Body.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Body.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "MapBuilding.h"
#import "LEBodyGetBuildings.h"
#import "LEBuildingView.h"


@implementation Body


@synthesize starId;
@synthesize starName;
@synthesize orbit;
@synthesize imageName;
@synthesize size;
@synthesize planetWater;
@synthesize ores;
@synthesize empireId;
@synthesize empireName;
@synthesize alignment;
@synthesize needsSurfaceRefresh;
@synthesize buildingCount;
@synthesize happiness;
@synthesize energy;
@synthesize food;
@synthesize ore;
@synthesize waste;
@synthesize water;
@synthesize buildingMap;
@synthesize surfaceImageName;
@synthesize currentBuilding;
@synthesize needsRefresh;
@dynamic canBuild;
@synthesize incomingForeignShips;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, type:%@, surfaceImageName:%@, empireId:%@, empireName:%@, x:%@, y:%@, starId:%@, starName:%@, orbit:%@, buildingCount:%@, needsSurfaceRefresh:%i, incomingForeignShips:%@, planetWater: %@, ores:%@", 
			self.id, self.name, self.type, self.surfaceImageName, self.empireId, self.empireName, self.x, self.y, self.starId, self.starName, self.orbit, self.buildingCount, self.needsSurfaceRefresh, self.incomingForeignShips, self.planetWater, self.ores];
}


- (void)dealloc {
	self.starId = nil;
	self.starName = nil;
	self.orbit = nil;
	self.imageName = nil;
	self.size = nil;
	self.planetWater = nil;
	self.ores = nil;
	self.empireId = nil;
	self.empireName = nil;
	self.alignment = nil;
	self.buildingCount = nil;
	self.happiness = nil;
	self.energy = nil;
	self.food = nil;
	self.ore = nil;
	self.waste = nil;
	self.water = nil;
	self.buildingMap = nil;
	self.surfaceImageName = nil;
	[self.currentBuilding removeObserver:self forKeyPath:@"needsReload"];
	self.currentBuilding = nil;
	self.incomingForeignShips = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Getters/Setters

- (BOOL)canBuild {
	return [self.buildingCount compare:self.size] == NSOrderedAscending;
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSMutableDictionary *)bodyData {
	[super parseData:bodyData];
	self.starId = [bodyData objectForKey:@"star_id"];
	self.starName = [bodyData objectForKey:@"star_name"];
	self.orbit = [Util asNumber:[bodyData objectForKey:@"orbit"]];
	self.imageName = [bodyData objectForKey:@"image"];
	self.size = [Util asNumber:[bodyData objectForKey:@"size"]];
	self.planetWater = [Util asNumber:[bodyData objectForKey:@"water"]];
	self.ores = [bodyData objectForKey:@"ore"];
	NSDictionary *empireData = [bodyData objectForKey:@"empire"];
	self.empireId = [Util idFromDict:empireData named:@"id"];
	self.empireName = [empireData objectForKey:@"name"];
	self.alignment = [empireData objectForKey:@"alignment"];
	self.needsSurfaceRefresh = _boolv([bodyData objectForKey:@"needs_surface_refresh"]);
	self.buildingCount = [Util asNumber:[bodyData objectForKey:@"building_count"]];
	if (!self.happiness) {
		self.happiness = [[[NoLimitResource alloc] init] autorelease];
	}
	[self.happiness parseFromData:bodyData withPrefix:@"happiness"];
	if (!self.energy) {
		self.energy = [[[StoredResource alloc] init] autorelease];
	}
	[self.energy parseFromData:bodyData withPrefix:@"energy"];
	if (!self.food) {
		self.food = [[[StoredResource alloc] init] autorelease];
	}
	[self.food parseFromData:bodyData withPrefix:@"food"];
	if (!self.ore) {
		self.ore = [[[StoredResource alloc] init] autorelease];
	}
	[self.ore parseFromData:bodyData withPrefix:@"ore"];
	if (!self.waste) {
		self.waste = [[[StoredResource alloc] init] autorelease];
	}
	[self.waste parseFromData:bodyData withPrefix:@"waste"];
	if (!self.water) {
		self.water = [[[StoredResource alloc] init] autorelease];
	}
	[self.water parseFromData:bodyData withPrefix:@"water"];
	
	NSMutableArray *incomingForeignShipData = [bodyData objectForKey:@"incoming_foreign_ships"];
	if (isNotNull(incomingForeignShipData)) {
		NSLog(@"INCOMING FOREIGN SHIP DATE: %@", incomingForeignShipData);
		NSMutableSet *newSet = [NSMutableSet setWithCapacity:[incomingForeignShipData count]];
		for (NSMutableDictionary *tmp in incomingForeignShipData) {
			[newSet addObject:[tmp objectForKey:@"date_arrives"]];
		}
		NSMutableSet *warnAboutSet;
		warnAboutSet = [newSet mutableCopy];
		if (self.incomingForeignShips) {
			[warnAboutSet minusSet:self.incomingForeignShips];
		}
		if ([warnAboutSet count] > 0) {
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"INCOMING SHIPS!" message:@"Incoming Foreign Ships detected. Go to your Spaceport for more information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
		}
		[warnAboutSet release];
		self.incomingForeignShips = newSet;
	} else {
		if (self.incomingForeignShips) {
			self.incomingForeignShips = nil;
		}
	}

	
	self.needsRefresh = YES;
}


- (void)tick:(NSInteger)interval {
	[self.energy tick:interval];
	[self.food tick:interval];
	[self.happiness tick:interval];
	[self.ore tick:interval];
	NSDecimalNumber *extraWaste = [[[self.waste tick:interval] retain] autorelease];
	[self.water tick:interval];
	
	if (self.currentBuilding) {
		[self.currentBuilding tick:interval];
	}
	
	if (extraWaste) {
		[self.happiness subtractFromCurrent:extraWaste];
	}

	[self.buildingMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		MapBuilding *mapBuilding = obj;
		[mapBuilding tick:interval];
		if (mapBuilding.needsReload) {
			[self loadBuildingMap];
		}
	}];
	
	self.needsRefresh = YES;
}


- (void)loadBuildingMap {
	[[[LEBodyGetBuildings alloc] initWithCallback:@selector(buildingMapLoaded:) target:self bodyId:self.id] autorelease];
}


- (void)loadBuilding:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl {
	[self clearBuilding];

	[[[LEBuildingView alloc] initWithCallback:@selector(buildingLoaded:) target:self buildingId:buildingId url:buildingUrl] autorelease];
}


- (void)clearBuilding {
	[self.currentBuilding removeObserver:self forKeyPath:@"needsReload"];
	self.currentBuilding = nil;
}


#pragma mark -
#pragma mark Callback Methods

- (id)buildingMapLoaded:(LEBodyGetBuildings *)request {
	self.surfaceImageName = request.surfaceImageName;
	//self.buildingMap = request.buildings;
	NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithCapacity:[request.buildings count]];
	
	[request.buildings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		MapBuilding *mapBuilding = [[MapBuilding alloc] init];
		[mapBuilding parseData:obj];
		[tmp setObject:mapBuilding forKey:key];
		[mapBuilding release];
	}];
	self.buildingMap = tmp;

	return nil;
}


- (id)buildingLoaded:(LEBuildingView *)request {
	Building *building = [BuildingUtil createBuilding:request];
	[building addObserver:self forKeyPath:@"needsReload" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	self.currentBuilding = building;
	return nil;
}


#pragma mark -
#pragma mark KVO Callback

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"needsReload"]) {
		Building *building = (Building *)object;
		[self loadBuilding:building.id buildingUrl:building.buildingUrl];
	}
}


@end
