//
//  HWAManager.m
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/7/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "HWAManager.h"
#import "HWAClient.h"
#import <TSMessages/TSMessage.h>

@interface HWAManager()

//Declares these as readwrite (default) so the data can be changed in private instead of in public
@property (strong, nonatomic) HWACondition *currentCondition;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSArray *hourlyForecast;
@property (strong, nonatomic) NSArray *dailyForecast;

//Private properties for location finding and weather data fetching
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL isFirstUpdate;
@property (strong, nonatomic) HWAClient *client;

@end

@implementation HWAManager

+ (instancetype) sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id) init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;

        _client = [[HWAClient alloc] init];
        
        [[[[RACObserve(self, currentLocation)
            ignore: nil]
           
           flattenMap: ^(CLLocation *newLocation) {
               return [RACSignal merge:@[
                                         [self updateCurrentConditions],
                                         [self updateDailyForecast],
                                         /*[self updateHourlyForecast]*/
                                         ]];
           }] deliverOn: RACScheduler.mainThreadScheduler]
         
           subscribeError:^(NSError *error) {
               [TSMessage showNotificationWithTitle: @"Error" subtitle: @"There was a problem retrieving weather data" type:TSMessageNotificationTypeError];
           }];
    }
    return self;
}

- (void) findCurrentLocation {
    self.isFirstUpdate = YES;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //First location update because it is cached
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    //Stop updating after location is found
    if (location.horizontalAccuracy > 0) {
        //Triggers RACObservable
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }
}

//#pragma mark Fetching and saving data after calling methods on client class

- (RACSignal *) updateCurrentConditions {
    return [[self.client fetchCurrentConditionsForLocation: self.currentLocation.coordinate] doNext: ^(HWACondition *condition) {
        self.currentCondition = condition;
    }];
}

- (RACSignal *) updateDailyForecast {
    return [[self.client fetchDailyForecastForLocation: self.currentLocation.coordinate] doNext: ^(NSArray *conditions) {
        self.dailyForecast = conditions;
    }];
}

//- (RACSignal *) updateHourlyForecast {
//    return [[self.client fetchHourlyForecastForLocation: self.currentLocation.coordinate] doNext: ^(NSArray *conditions) {
//        self.hourlyForecast = conditions;
//    }];
//}

@end
