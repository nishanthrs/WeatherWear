//
//  HWACondition.h
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/7/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

#define CLOTHE_NAME @"Clothe Name"
#define CLOTHE_DESCR @"Clothe Description"

@interface HWACondition : MTLModel <MTLJSONSerializing> //Delegate/Protocol to allow Obj-C properties to use JSON

//Properties to store weather data
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *temperature;
@property (strong, nonatomic) NSNumber *tempHigh;
@property (strong, nonatomic) NSNumber *tempLow;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSDate *sunrise;
@property (strong, nonatomic) NSDate *sunset;
@property (strong, nonatomic) NSString *conditionDescription;
@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSNumber *windBearing;
@property (strong, nonatomic) NSNumber *windSpeed;
@property (strong, nonatomic) NSString *icon;

+ (NSArray *) clothingMap;

//Helper method to display weather conditions using image files
- (NSString *) imageName;
- (NSString *) clothingImageName;

@end
