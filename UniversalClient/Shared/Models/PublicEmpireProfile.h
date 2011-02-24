//
//  PublicEmpireProfile.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PublicEmpireProfile : NSObject {
}


@property (nonatomic, retain) NSString *empireId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDecimalNumber *numPlanets;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *empireDescription;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *skype;
@property (nonatomic, retain) NSString *playerName;
@property (nonatomic, retain) NSDate *lastLogin;
@property (nonatomic, retain) NSDate *founded;
@property (nonatomic, retain) NSString *speciesName;
@property (nonatomic, retain) NSMutableArray *colonies;
@property (nonatomic, retain) NSMutableArray *medals;
@property (nonatomic, retain) NSString *allianceId;
@property (nonatomic, retain) NSString *allianceName;


- (void)parseData:(NSDictionary *)data;


@end
