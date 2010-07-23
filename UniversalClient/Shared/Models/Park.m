//
//  Park.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Park.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingThrowParty.h"


@implementation Park

@synthesize canThrowParty;
@synthesize secondsRemaining;
@synthesize happinessPerParty;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.happinessPerParty = nil;
	[super dealloc];
}

#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	NSLog(@"Tick");
	if (self.secondsRemaining > 0) {
		self.secondsRemaining -= interval;
		if (self.secondsRemaining <= 0) {
			self.secondsRemaining = 0;
			self.needsReload = YES;
		} else {
			self.needsRefresh = YES;
		}
	}
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *partyData = [data objectForKey:@"party"];
	self.canThrowParty = [[partyData objectForKey:@"can_throw"] boolValue];
	self.secondsRemaining = _intv([partyData objectForKey:@"seconds_remaining"]);
	self.happinessPerParty = [partyData objectForKey:@"happiness_from_party"];
}


- (void)generateSections {
	
	NSMutableArray *partyRows = [NSMutableArray arrayWithCapacity:2];
	if (self.canThrowParty) {
		[partyRows addObject:[NSNumber numberWithInt:BUILDING_ROW_THROW_PARTY]];
	} else {
		[partyRows addObject:[NSNumber numberWithInt:BUILDING_ROW_PARTY_PENDING]];
	}
	self.sections = _array([self generateProductionSection], _dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", partyRows, @"rows"), [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_THROW_PARTY:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_PARTY_PENDING:
			return tableView.rowHeight;
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_THROW_PARTY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *throwPartyCell = [LETableViewCellButton getCellForTableView:tableView];
			throwPartyCell.textLabel.text = @"Throw Party";
			cell = throwPartyCell;
			break;
		case BUILDING_ROW_PARTY_PENDING:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *partyPendingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			if (self.secondsRemaining > 0) {
				partyPendingCell.label.text = @"In progress";
				partyPendingCell.content.text = [Util prettyDuration:self.secondsRemaining];
			} else {
				partyPendingCell.label.text = @"Party";
				partyPendingCell.content.text = @"Not enough food";
			}
			cell = partyPendingCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_THROW_PARTY:
			[[[LEBuildingThrowParty alloc] initWithCallback:@selector(throwingParty:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Callback Methods

- (id)throwingParty:(LEBuildingThrowParty *)request {
	self.needsReload = YES;
	return nil;
}


@end
