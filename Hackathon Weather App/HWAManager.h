//
//  HWAManager.h
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/7/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
// Class that finds device's location and fetches appropriate weather data

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "HWACondition.h"

@interface HWAManager : NSObject <CLLocationManagerDelegate>

//instancetype keyword returns object of specified subclass of HWAManager, whereas class method would return any subclass
+ (instancetype) sharedManager;

//Readonly used (in place of readwrite) in order to set properties as constants
//Properties store data of location, condition, and forecasts
@property (strong, nonatomic, readonly) CLLocation *currentLocation;
@property (strong, nonatomic, readonly) HWACondition *currentCondition;
@property (strong, nonatomic, readonly) NSArray *hourlyForecast;
@property (strong, nonatomic, readonly) NSArray *dailyForecast;

- (void) findCurrentLocation;

@end
