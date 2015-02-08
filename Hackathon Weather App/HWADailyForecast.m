//
//  HWADailyForecast.m - Subclass of HWACondition
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/7/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "HWADailyForecast.h"

@implementation HWADailyForecast

//Method that overrides JSONKeyPathsByPropertyKey to fix small discrepancy with max and min temperatures in OpenWeather API
+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    //Gets HWACondition map from its superclass method and creates copy of it
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    //Changes the paths to what daily forecast needs
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    
    return paths;
}

@end
