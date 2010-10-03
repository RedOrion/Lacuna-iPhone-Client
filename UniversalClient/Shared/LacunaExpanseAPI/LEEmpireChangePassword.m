//
//  LEEmpireChangePassword.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireChangePassword.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireChangePassword


@synthesize newPassword;
@synthesize newPasswordConfirm;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget newPassword:(NSString *)inNewPassword newPasswordConfirm:(NSString *)inNewPasswordConfirm {
	self.newPassword = inNewPassword;
	self.newPasswordConfirm = inNewPasswordConfirm;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.newPassword, self.newPasswordConfirm);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"change_password";
}


- (void)dealloc {
	self.newPassword = nil;
	self.newPasswordConfirm = nil;
	[super dealloc];
}


@end
