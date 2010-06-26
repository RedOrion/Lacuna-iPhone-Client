//
//  EditEmpireProfileText.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EditEmpireProfileText.h"
#import "LEEmpireEditProfile.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "Empire.h"


@implementation EditEmpireProfileText


@synthesize textCell;
@synthesize textName;
@synthesize textKey;
@synthesize empire;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];

	self.textCell = [LETableViewCellTextView getCellForTableView:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSLog(@"Name: %@", self.textName);
	NSLog(@"Key: %@", self.textName);
	
	self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", self.textName];
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:self.textName]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellTextView getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.textCell;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.textCell = nil;
	[self viewDidUnload];
}


- (void)dealloc {
	self.textName = nil;
	self.textKey = nil;
	self.empire = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:self.textKey text:self.textCell.textView.text empire:self.empire];
}


#pragma mark -
#pragma mark Callback Methods

- (id)textUpdated:(LEEmpireEditProfile *)request {
	[[self navigationController] popViewControllerAnimated:YES];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (EditEmpireProfileText *)createForEmpire:(Empire *)inEmpire textName:(NSString *)name textKey:(NSString *)key text:(NSString *)text {
	EditEmpireProfileText *editEmpireProfileText = [[[EditEmpireProfileText alloc] init] autorelease];
	
	editEmpireProfileText.empire = inEmpire;
	editEmpireProfileText.textKey = key;
	editEmpireProfileText.textName = name;
	if ((id)text == [NSNull null]) {
		editEmpireProfileText.textCell.textView.text = @"";
	} else {
		editEmpireProfileText.textCell.textView.text = text;
	}
	
	return editEmpireProfileText;
}


@end
