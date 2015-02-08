//
//  HWAClient.h
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/7/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.

// Class responbility - to create and fetch API requests and parse them
// Functional programming - paradigm that produces output by simplifying many inputs

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//Reactive Cocoa (RAC) - Obj-C framework for Functional Programming that provides APIs for creating and transforming values
//RAC - Creates operations and actions based on future data
//RAC - Interface for asynchronous operations (inputs)
//#import <ReactiveCocoa/ReactiveCocoa.h>


@interface HWAClient : NSObject

//Master method that builds signal to fetch data from url; displays errors as well if data is irretrievable
- (RACSignal *) fetchJSONFromURL: (NSURL *) url;
//Methods to fetch data from url using master method
- (RACSignal *) fetchCurrentConditionsForLocation: (CLLocationCoordinate2D) coordinate;
//- (RACSignal *) fetchHourlyForecastForLocation: (CLLocationCoordinate2D) coordinate;
- (RACSignal *) fetchDailyForecastForLocation: (CLLocationCoordinate2D) coordinate;

@end
