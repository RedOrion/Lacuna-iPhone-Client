//
//  Util.m
//  DKTest
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Util.h"


@implementation Util

+ (NSString *)prettyDuration:(NSInteger)seconds {
	NSInteger minutes = seconds / 60;
	seconds = seconds % 60;
	NSInteger hours = minutes / 60;
	minutes = minutes % 60;
	NSInteger days = hours / 24;
	hours = hours %24;
	
	if (days) {
		return [NSString stringWithFormat:@"%iD, %02i:%02i:%02i", days, hours, minutes, seconds];
	} else {
		return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
	}
}


+ (CGFloat)heightForText:(NSString *)text inFrame:(CGRect)frame withFont:(UIFont *)font {
	// NOTE: FLT_MAX is a large float. Returned height will be less.
	CGSize cellSize = CGSizeMake(frame.size.width - 10, FLT_MAX);
	cellSize = [text sizeWithFont:font 
				   constrainedToSize:cellSize
					   lineBreakMode:UILineBreakModeWordWrap];
	return cellSize.height + 10;
}


+ (NSDate *)date:(NSString *)serverDateString {
	NSDateFormatter *serverDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[serverDateFormatter setDateFormat:@"dd MM yyyy HH:mm:ss ZZZ"];
	return [serverDateFormatter dateFromString:serverDateString];
}


+ (NSString *)prettyDate:(NSString *)serverDateString {
	NSDateFormatter *localDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[localDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	
	NSDate *date = [Util date:serverDateString];
	return [localDateFormatter stringFromDate:date];
}


+ (NSString *)prettyNumber:(NSNumber *)number {
	NSInteger value = [number intValue];
	if (value > 2000000000) {
		return [NSString stringWithFormat:@"%iB", (value/1000000000)];
	} else if (value > 2000000) {
		return [NSString stringWithFormat:@"%iM", (value/1000000)];
	} else if (value > 2000) {
		return [NSString stringWithFormat:@"%iK", (value/1000)];
	} else {
		return [NSString stringWithFormat:@"%i", value];
	}
}


+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


@end
