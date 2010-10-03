//
//  ViewUniverseController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniverseGotoController.h"

@class StarMap;


@interface ViewUniverseController : UIViewController <UIScrollViewDelegate, UniverseGotoControllerDelegate> {
	UIScrollView *scrollView;
	UIView *map;
	UIActivityIndicatorView *loadingView;
	NSMutableDictionary *inUseStarCells;
	NSMutableArray *reusableStarCells;
	NSMutableDictionary *inUseBodyCells;
	NSMutableArray *reusableBodyCells;
	StarMap *starMap;
	BOOL isUpdating;
	BOOL updateLocation;
}


@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *map;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) NSMutableDictionary *inUseStarCells;
@property (nonatomic, retain) NSMutableArray *reusableStarCells;
@property (nonatomic, retain) NSMutableDictionary *inUseBodyCells;
@property (nonatomic, retain) NSMutableArray *reusableBodyCells;
@property (nonatomic, retain) StarMap *starMap;


- (IBAction)logout;
- (IBAction)showGotoPage;
- (IBAction)clear;


@end
