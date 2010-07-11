//
//  ViewSpiesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewSpiesController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "RenameSpyController.h"
#import "AssignSpyController.h"
#import "LETableViewCellSpyInfo.h"
#import "Util.h"
#import "Intelligence.h"
#import "Spy.h"


typedef enum {
	ROW_SPY_INFO,
	ROW_ASSIGN_BUTTON,
	ROW_RENAME_BUTTON,
	ROW_BURN_BUTTON
} ROW;


@implementation ViewSpiesController


@synthesize intelligenceBuilding;
@synthesize spiesLastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Spies";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.intelligenceBuilding addObserver:self forKeyPath:@"spiesUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.intelligenceBuilding.spies) {
		[self.intelligenceBuilding loadSpies];
	} else {
		if (self.spiesLastUpdated) {
			if ([self.spiesLastUpdated compare:self.intelligenceBuilding.spiesUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.spiesLastUpdated = self.intelligenceBuilding.spiesUpdated;
			}
		} else {
			self.spiesLastUpdated = self.intelligenceBuilding.spiesUpdated;
		}
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.intelligenceBuilding removeObserver:self forKeyPath:@"spiesUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.intelligenceBuilding && self.intelligenceBuilding.spies) {
		return [self.intelligenceBuilding.spies count];
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Spy *spy = [self.intelligenceBuilding.spies objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			return [LETableViewCellSpyInfo getHeightForTableView:tableView];
			break;
		case ROW_BURN_BUTTON:
		case ROW_RENAME_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case ROW_ASSIGN_BUTTON:
			if (spy.isAvailable) {
				return [LETableViewCellButton getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Spy *spy = [self.intelligenceBuilding.spies objectAtIndex:indexPath.section];
    
    UITableViewCell *cell;
	
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			; //DO NOT REMOVE
			LETableViewCellSpyInfo *spyInfoCell = [LETableViewCellSpyInfo getCellForTableView:tableView];
			[spyInfoCell setData:spy];
			cell = spyInfoCell;
			break;
		case ROW_BURN_BUTTON:
			; //DO NOT REMOVE
			LETableViewCellButton *burnButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			burnButtonCell.textLabel.text = @"Burn spy";
			cell = burnButtonCell;
			break;
		case ROW_RENAME_BUTTON:
			; //DO NOT REMOVE
			LETableViewCellButton *renameButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			renameButtonCell.textLabel.text = @"Rename spy";
			cell = renameButtonCell;
			break;
		case ROW_ASSIGN_BUTTON:
			if (spy.isAvailable) {
				LETableViewCellButton *assignButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				assignButtonCell.textLabel.text = @"Assign spy";
				cell = assignButtonCell;
			} else {
				LETableViewCellLabeledText *assignedCell = [LETableViewCellLabeledText getCellForTableView:tableView];
				assignedCell.label.text = @"Busy for";
				//assignedCell.content.text = [Util formatDate:spy.assignmentEnds];
				assignedCell.content.text = [Util prettyDuration:spy.secondsRemaining];
				cell = assignedCell;
			}
			break;
		default:
			cell = nil;
			break;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Spy *spy = [self.intelligenceBuilding.spies objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_BURN_BUTTON:
			[self.intelligenceBuilding burnSpy:spy];
			break;
		case ROW_RENAME_BUTTON:
			; //DO NOT REMOVE
			RenameSpyController *renameSpyController = [RenameSpyController create];
			renameSpyController.intelligenceBuilding = self.intelligenceBuilding;
			renameSpyController.spy = spy;
			renameSpyController.nameCell.textField.text = spy.name;
			[self.navigationController pushViewController:renameSpyController animated:YES];
			break;
		case ROW_ASSIGN_BUTTON:
			if (spy.isAvailable) {
				AssignSpyController *assignSpyController = [AssignSpyController create];
				assignSpyController.intelligenceBuilding = self.intelligenceBuilding;
				assignSpyController.spy = spy;
				[self.navigationController pushViewController:assignSpyController animated:YES];
			}
			break;
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.intelligenceBuilding = nil;
	self.spiesLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewSpiesController *)create {
	return [[[ViewSpiesController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"spiesUpdated"]) {
		[self.tableView reloadData];
		self.spiesLastUpdated = self.intelligenceBuilding.spiesUpdated;
	}
}


@end

