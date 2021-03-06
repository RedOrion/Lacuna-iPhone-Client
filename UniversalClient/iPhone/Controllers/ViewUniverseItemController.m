//
//  ViewUniverseItemController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewUniverseItemController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BaseMapItem.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellBody.h"
#import "LETableViewCellStar.h"
#import "RenameBodyController.h"
#import "ViewUniverseMiningPlatformsController.h"
#import "ViewUniverseIncomingShipsController.h"
#import "ViewUniverseOrbitingShipsController.h"
#import "SendShipController.h"
#import "SendFleetController.h"
#import "SendSpiesController.h"
#import "FetchSpiesController.h"
#import "AppDelegate_Phone.h"
#import "ViewUniverseItemUnsendableShipsController.h"
#import "ViewLawsPubliclyController.h"


typedef enum {
	SECTION_LOADING,
	SECTION_INFO,
	SECTION_SPY_ACTIONS,
	SECTION_SHIP_ACTIONS,
	SECTION_COMPOSITION,
    SECTION_INFLUENCE,
} SECTIONS;


typedef enum {
	ROW_LOADING,
	ROW_INFO,
	ROW_SEND_SPIES,
	ROW_FETCH_SPIES,
	ROW_VIEW_INCOMING_SHIPS,
	ROW_VIEW_ORBITING_SHIPS,
	ROW_VIEW_MINING_PLATFORMS,
	ROW_SEND_SHIP,
	ROW_SEND_FLEET,
	ROW_UNSENDABLE_SHIPS,
	ROW_PLOTS,
	ROW_WATER,
	ROW_RENAME,
	ROW_VIEW_MY_WORLD,
    ROW_INFLUENCING_STATION,
    ROW_VIEW_LAWS,
} ROWS;


@interface ViewUniverseItemController(PrivateMethods)

- (void)genSectionInfo;

@end


@implementation ViewUniverseItemController


@synthesize mapItem;
@synthesize sections;
@synthesize oreKeysSorted;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Loading";
	
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self genSectionInfo];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSMutableDictionary *sectionData = [self.sections objectAtIndex:section];
	if (_intv([sectionData objectForKey:@"type"]) == SECTION_COMPOSITION) {
		return [self.oreKeysSorted count] + 2;
	} else {
		return [[sectionData objectForKey:@"rows"] count];
	}

}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *sectionData = [self.sections objectAtIndex:indexPath.section];
	if (_intv([sectionData objectForKey:@"type"]) == SECTION_COMPOSITION && indexPath.row > 1) {
		return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
	} else {
		ROWS row = _intv([[sectionData objectForKey:@"rows"] objectAtIndex:indexPath.row]);
		
		switch (row) {
			case ROW_LOADING:
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
				break;
			case ROW_INFO:
				if ([self.mapItem.type isEqualToString:@"star"]) {
					return [LETableViewCellStar getHeightForTableView:tableView];
				} else {
					return [LETableViewCellBody getHeightForTableView:tableView];
				}
				break;
			case ROW_SEND_SPIES:
			case ROW_FETCH_SPIES:
			case ROW_VIEW_INCOMING_SHIPS:
			case ROW_VIEW_ORBITING_SHIPS:
			case ROW_VIEW_MINING_PLATFORMS:
			case ROW_SEND_SHIP:
			case ROW_SEND_FLEET:
			case ROW_UNSENDABLE_SHIPS:
			case ROW_RENAME:
			case ROW_VIEW_MY_WORLD:
            case ROW_INFLUENCING_STATION:
            case ROW_VIEW_LAWS:
				return [LETableViewCellButton getHeightForTableView:tableView];
				break;
			case ROW_PLOTS:
			case ROW_WATER:
				return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
				break;
			default:
				return 0.0;
				break;
		}
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	NSMutableDictionary *sectionData = [self.sections objectAtIndex:indexPath.section];
	if (_intv([sectionData objectForKey:@"type"]) == SECTION_COMPOSITION && indexPath.row > 1) {
		id oreTypeKey = [self.oreKeysSorted objectAtIndex:(indexPath.row-2)];
		id oreTypeValue = [((Body *)self.mapItem).ores objectForKey:oreTypeKey];
		LETableViewCellLabeledIconText *oreCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
		oreCell.label.text = [Util prettyCodeValue:[NSString stringWithFormat:@"%@", oreTypeKey]];
		oreCell.icon.image = ORE_ICON;
		oreCell.content.text = [NSString stringWithFormat:@"%@", oreTypeValue];
		cell = oreCell;
	} else {
		ROWS row = _intv([[sectionData objectForKey:@"rows"] objectAtIndex:indexPath.row]);
		
		switch (row) {
			case ROW_LOADING:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Map Item";
				loadingCell.content.text = @"Loading";
				cell = loadingCell;
				break;
			case ROW_INFO:
				; //DO NOT REMOVE
				if ([self.mapItem.type isEqualToString:@"star"]) {
					LETableViewCellStar *infoCell = [LETableViewCellStar getCellForTableView:tableView isSelectable:NO];
					[infoCell setStar:((Star *)self.mapItem)];
					cell = infoCell;
				} else {
					Body *body = (Body *)self.mapItem;
					LETableViewCellBody *infoCell = [LETableViewCellBody getCellForTableView:tableView isSelectable:NO];
					infoCell.planetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/star_system/%@.png", body.imageName]];
					infoCell.planetLabel.text = body.name;
					infoCell.systemLabel.text = body.starName;
					infoCell.orbitLabel.text = [NSString stringWithFormat:@"%@", body.orbit];
					infoCell.empireLabel.text = body.empireName;
					cell = infoCell;
				}
				break;
			case ROW_SEND_SPIES:
				; //DO NOT REMOVE
				LETableViewCellButton *viewSpiesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				viewSpiesButtonCell.textLabel.text = @"Send Spy Here";
				cell = viewSpiesButtonCell;
				break;
			case ROW_FETCH_SPIES:
				; //DO NOT REMOVE
				LETableViewCellButton *sendSpyButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				sendSpyButtonCell.textLabel.text = @"Fetch Spy Here";
				cell = sendSpyButtonCell;
				break;
			case ROW_VIEW_INCOMING_SHIPS:
				; //DO NOT REMOVE
				LETableViewCellButton *viewIncomingShipsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				viewIncomingShipsButtonCell.textLabel.text = @"View Incoming Ships";
				cell = viewIncomingShipsButtonCell;
				break;
			case ROW_VIEW_ORBITING_SHIPS:
				; //DO NOT REMOVE
				LETableViewCellButton *viewOrbitingShipsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				viewOrbitingShipsButtonCell.textLabel.text = @"View Orbiting Ships";
				cell = viewOrbitingShipsButtonCell;
				break;
			case ROW_VIEW_MINING_PLATFORMS:
				; //DO NOT REMOVE
				LETableViewCellButton *viewMiningPlatformsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				viewMiningPlatformsButtonCell.textLabel.text = @"View Mining Platforms";
				cell = viewMiningPlatformsButtonCell;
				break;
			case ROW_SEND_SHIP:
				; //DO NOT REMOVE
				LETableViewCellButton *sendShipButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				sendShipButtonCell.textLabel.text = @"Send Ship Here";
				cell = sendShipButtonCell;
				break;
			case ROW_SEND_FLEET:
				; //DO NOT REMOVE
				LETableViewCellButton *sendFleetButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				sendFleetButtonCell.textLabel.text = @"Send Fleet Here";
				cell = sendFleetButtonCell;
				break;
			case ROW_UNSENDABLE_SHIPS:
				; //DO NOT REMOVE
				LETableViewCellButton *unsendableShipsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				unsendableShipsButtonCell.textLabel.text = @"View unsendable ships";
				cell = unsendableShipsButtonCell;
				break;
			case ROW_PLOTS:
				; //DO NOT REMOVE
				LETableViewCellLabeledIconText *plotsCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
				plotsCell.label.text = @"Plots";
				plotsCell.icon.image = PLOTS_ICON;
				plotsCell.content.text = [((Body *)self.mapItem).size stringValue];
				cell = plotsCell;
				break;
			case ROW_WATER:
				; //DO NOT REMOVE
				LETableViewCellLabeledIconText *waterCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
				waterCell.label.text = @"Water";
				waterCell.icon.image = WATER_ICON;
				waterCell.content.text = [((Body *)self.mapItem).planetWater stringValue];
				cell = waterCell;
				break;
			case ROW_RENAME:
				; //DO NOT REMOVE
				LETableViewCellButton *renameButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				renameButtonCell.textLabel.text = @"Rename";
				cell = renameButtonCell;
				break;
			case ROW_VIEW_MY_WORLD:
				; //DO NOT REMOVE
				LETableViewCellButton *showInMyWorldsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				showInMyWorldsButtonCell.textLabel.text = @"Show in my worlds";
				cell = showInMyWorldsButtonCell;
				break;
            case ROW_INFLUENCING_STATION:
				; //DO NOT REMOVE
				LETableViewCellButton *influenceingStationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				influenceingStationButtonCell.textLabel.text = self.mapItem.stationName;
				cell = influenceingStationButtonCell;
				break;
            case ROW_VIEW_LAWS:
				; //DO NOT REMOVE
				LETableViewCellButton *viewLawsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				viewLawsButtonCell.textLabel.text = @"View Laws";
				cell = viewLawsButtonCell;
				break;
			default:
				cell = nil;
				break;
		}
	}
		
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected: %@", indexPath);
	NSMutableDictionary *sectionData = [self.sections objectAtIndex:indexPath.section];
	if (_intv([sectionData objectForKey:@"type"]) != SECTION_COMPOSITION) {
		ROWS row = _intv([[sectionData objectForKey:@"rows"] objectAtIndex:indexPath.row]);
		Session *session = [Session sharedInstance];
        AppDelegate_Phone *delgate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;

		switch (row) {
			case ROW_SEND_SPIES:
				; //DO NOT REMOVE
				SendSpiesController *sendSpiesController = [SendSpiesController create];
				sendSpiesController.mapItem = self.mapItem;
				sendSpiesController.sendFromBodyId = session.body.id;
				[self.navigationController pushViewController:sendSpiesController animated:YES];
				break;
			case ROW_FETCH_SPIES:
				; //DO NOT REMOVE
				FetchSpiesController *fetchSpiesController = [FetchSpiesController create];
				fetchSpiesController.mapItem = self.mapItem;
				fetchSpiesController.fetchToBodyId = session.body.id;
				[self.navigationController pushViewController:fetchSpiesController animated:YES];
				break;
			case ROW_VIEW_INCOMING_SHIPS:
				; //DO NOT REMOVE
				ViewUniverseIncomingShipsController *viewUniverseIncomingShipsController = [ViewUniverseIncomingShipsController create];
				viewUniverseIncomingShipsController.mapItem = self.mapItem;
				[self.navigationController pushViewController:viewUniverseIncomingShipsController animated:YES];
				break;
			case ROW_VIEW_ORBITING_SHIPS:
				; //DO NOT REMOVE
				ViewUniverseOrbitingShipsController *viewUniverseOrbitingShipsController = [ViewUniverseOrbitingShipsController create];
				viewUniverseOrbitingShipsController.mapItem = self.mapItem;
				[self.navigationController pushViewController:viewUniverseOrbitingShipsController animated:YES];
				break;
			case ROW_VIEW_MINING_PLATFORMS:
				; //DO NOT REMOVE
				ViewUniverseMiningPlatformsController *viewUniverseMiningPlatformsController = [ViewUniverseMiningPlatformsController create];
				viewUniverseMiningPlatformsController.mapItem = self.mapItem;
				[self.navigationController pushViewController:viewUniverseMiningPlatformsController animated:YES];
				break;
			case ROW_SEND_SHIP:
				; //DO NOT REMOVE
				SendShipController *sendShipController = [SendShipController create];
				sendShipController.mapItem = self.mapItem;
				sendShipController.sendFromBodyId = session.body.id;
				[self.navigationController pushViewController:sendShipController animated:YES];
				break;
			case ROW_SEND_FLEET:
				; //DO NOT REMOVE
				SendFleetController *sendFleetController = [SendFleetController create];
				sendFleetController.mapItem = self.mapItem;
				sendFleetController.sendFromBodyId = session.body.id;
				[self.navigationController pushViewController:sendFleetController animated:YES];
				break;
			case ROW_UNSENDABLE_SHIPS:
				; //DO NOT REMOVE
				ViewUniverseItemUnsendableShipsController *viewUniverseItemUnsendableShipsController = [ViewUniverseItemUnsendableShipsController create];
				viewUniverseItemUnsendableShipsController.mapItem = self.mapItem;
				viewUniverseItemUnsendableShipsController.sendFromBodyId = session.body.id;
				[self.navigationController pushViewController:viewUniverseItemUnsendableShipsController animated:YES];
				break;
			case ROW_RENAME:
				; //DO NOT REMOVE
				RenameBodyController *renameBodyController = [RenameBodyController create];
				renameBodyController.body = (Body *)self.mapItem;
				[self.navigationController pushViewController:renameBodyController animated:YES];
				break;
			case ROW_VIEW_MY_WORLD:
				; //DO NOT REMOVE
				[delgate showMyWorld:self.mapItem.id];
				[self.navigationController popToRootViewControllerAnimated:NO];
				break;
            case ROW_INFLUENCING_STATION:
				; //DO NOT REMOVE
                [delgate setStarMapGridX:self.mapItem.stationX gridY:self.mapItem.stationY];
                [self.navigationController popViewControllerAnimated:YES];
				break;
            case ROW_VIEW_LAWS:
				; //DO NOT REMOVE
				ViewLawsPubliclyController *viewLawsPubliclyController = [ViewLawsPubliclyController create];
                viewLawsPubliclyController.stationId = self.mapItem.stationId;
                [self.navigationController pushViewController:viewLawsPubliclyController animated:YES];
				break;
            default:
                break;
		}
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	self.sections = nil;
	self.mapItem = nil;
	self.oreKeysSorted = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)genSectionInfo {
	if (self.mapItem) {
		self.sections = [NSMutableArray arrayWithCapacity:5];

		if ([self.mapItem.type isEqualToString:@"asteroid"] || [self.mapItem.type isEqualToString:@"gas giant"] || [self.mapItem.type isEqualToString:@"habitable planet"]) {
			Session *session = [Session sharedInstance];
			Body *body = ((Body *)self.mapItem);
			if ([body.empireId isEqualToString:session.empire.id]) {
				[self.sections addObject:_dict([NSDecimalNumber numberWithInt:SECTION_INFO], @"type", [self.mapItem.type capitalizedString], @"name", _array([NSDecimalNumber numberWithInt:ROW_INFO], [NSDecimalNumber numberWithInt:ROW_RENAME], [NSDecimalNumber numberWithInt:ROW_VIEW_MY_WORLD]), @"rows")];
			} else {
				[self.sections addObject:_dict([NSDecimalNumber numberWithInt:SECTION_INFO], @"type", [self.mapItem.type capitalizedString], @"name", _array([NSDecimalNumber numberWithInt:ROW_INFO]), @"rows")];
			}

		} else {
			[self.sections addObject:_dict([NSDecimalNumber numberWithInt:SECTION_INFO], @"type", [self.mapItem.type capitalizedString], @"name", _array([NSDecimalNumber numberWithInt:ROW_INFO]), @"rows")];
		}

        if (isNotNull(self.mapItem.stationId)) {
			[self.sections addObject:_dict([NSDecimalNumber numberWithInt:SECTION_INFLUENCE], @"type", @"Influenced By", @"name", _array([NSDecimalNumber numberWithInt:ROW_INFLUENCING_STATION], [NSDecimalNumber numberWithInt:ROW_VIEW_LAWS]), @"rows")];
        }

		if ([self.mapItem.type isEqualToString:@"habitable planet"]) {
            Body *body = (Body *)self.mapItem;
			if (body.empireId) {
				[self.sections addObject:_dict([NSDecimalNumber numberWithInt:SECTION_SPY_ACTIONS], @"type", @"Spies", @"name", _array([NSDecimalNumber numberWithInt:ROW_SEND_SPIES]), @"rows")];
			}
		}

		NSMutableArray *shipActionRows = _array([NSDecimalNumber numberWithInt:ROW_VIEW_INCOMING_SHIPS], [NSDecimalNumber numberWithInt:ROW_VIEW_ORBITING_SHIPS]);
		if ([self.mapItem.type isEqualToString:@"asteroid"]) {
			[shipActionRows addObject:[NSDecimalNumber numberWithInt:ROW_VIEW_MINING_PLATFORMS]];
		}
		[shipActionRows addObject:[NSDecimalNumber numberWithInt:ROW_SEND_SHIP]];
		[shipActionRows addObject:[NSDecimalNumber numberWithInt:ROW_SEND_FLEET]];
		[shipActionRows addObject:[NSDecimalNumber numberWithInt:ROW_UNSENDABLE_SHIPS]];

		[self.sections addObject:_dict([NSDecimalNumber numberWithInt:SECTION_SHIP_ACTIONS], @"type", @"Ships", @"name", shipActionRows, @"rows")];
		
		if ([self.mapItem.type isEqualToString:@"asteroid"] || [self.mapItem.type isEqualToString:@"gas giant"] || [self.mapItem.type isEqualToString:@"habitable planet"]) {
			self.oreKeysSorted = [[((Body *)self.mapItem).ores allKeys] sortedArrayUsingSelector:@selector(compare:)];
			[self.sections addObject:_dict([NSDecimalNumber numberWithInt:SECTION_COMPOSITION], @"type", @"Composition", @"name", _array([NSDecimalNumber numberWithInt:ROW_PLOTS], [NSDecimalNumber numberWithInt:ROW_WATER]), @"rows")];
		}
	} else {
		self.sections = _array(_dict([NSDecimalNumber numberWithInt:SECTION_LOADING], @"type", @"Loading", @"name", _array([NSDecimalNumber numberWithInt:ROW_LOADING]), @"rows"));
	}

	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.sections count]];
	for (NSMutableDictionary *sectionData in self.sections) {
		[tmp addObject:[LEViewSectionTab tableView:self.tableView withText:[sectionData objectForKey:@"name"]]];
	}
	self.sectionHeaders = tmp;
	
	self.navigationItem.title = self.mapItem.name;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewUniverseItemController *)create {
	return [[[ViewUniverseItemController alloc] init] autorelease];
}


@end

