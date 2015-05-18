//
//  Station.h
//  CodeChallenge3
//
//  Created by Michael Sevy on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Station : NSObject


//@property (readonly, nonatomic)float latitude;
//@property (readonly, nonatomic)float longitude;
//
//@property float latitude;
//@property float longitude;
@property NSString *name;

@property NSNumber *latitude;
@property NSNumber *longitude;



//-(void)passingCoor:(CLLocationCoordinate2D *)coordinates;





@end
