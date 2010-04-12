//
//  Util.h
//  DKTest
//
//  Created by Kevin Runde on 4/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject {

}


+ (NSString *)prettyDuration:(NSInteger)seconds;
+ (CGFloat)heightForText:(NSString *)text inFrame:(CGRect)frame withFont:(UIFont *)font;
+ (NSString *)prettyDate:(NSString *)serverDateString;


@end
