//
//  HWAClient.m
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/7/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "HWAClient.h"
#import "HWACondition.h"
#import "HWADailyForecast.h"

//Private interface of HWAClient
@interface HWAClient ()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation HWAClient

//Creates NSURLSession with defaultSessionConfiguration
- (id) init {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration: configuration]; //Underscore before to access private property
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching: %@",url.absoluteString);
    
    // 1
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 2
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (! error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (! jsonError) {
                    // 1
                    [subscriber sendNext:json];
                    NSLog(@"yes");
                }
                else {
                    // 2
                    [subscriber sendError:jsonError];
                }
            }
            else {
                // 2
                [subscriber sendError:error];
            }
            
            // 3
            [subscriber sendCompleted];
        }];
        
        // 3
        [dataTask resume];
        
        // 4
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        // 5
        NSLog(@"%@",error);
    }];
}

//- (RACSignal *) fetchJSONFromURL:(NSURL *)url {
//    NSLog(@"Fetching: %@", url.absoluteString);
//    
//    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
//            //If error occurs when user tries to retrieve json data from url, notify user; otherwise, send json data in an array or dictionary
//            if (! error) {
//                NSError *jsonError = nil;
//                id json = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: &jsonError];
//                if (! jsonError) {
//                    [subscriber sendNext: json];
//                }
//                else {
//                    [subscriber sendError: jsonError];
//                }
//            }
//            else {
//                [subscriber sendError: error];
//            }
//            [subscriber sendCompleted];
//        }];
//        
//        [dataTask resume];
//        
//        return [RACDisposable disposableWithBlock:^{
//            [dataTask cancel];
//        }];
//    }] doError: ^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
//}

- (RACSignal *) fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    //Format the url with latitude and longitude
    NSString *urlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString: urlString];
    
    return [[self fetchJSONFromURL: url] map: ^(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass: [HWACondition class] fromJSONDictionary: json error: nil];
    }];
}

//- (RACSignal *) fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
//    NSString *urlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12",coordinate.latitude, coordinate.longitude];
//    NSURL *url = [NSURL URLWithString: urlString];
//    
//    return [[self fetchJSONFromURL: url] map: ^(NSDictionary *json) {
//        RACSequence *list = [json[@"list"] rac_sequence]; //RACSequence allows Reactive Cocoa methods on json lists
//        return [[list map: ^(NSDictionary *item) { //Maps each object in list and returns new list of objects
//            return [MTLJSONAdapter modelOfClass: [HWACondition class] fromJSONDictionary: json error: nil];
//        }] array]; //Converts json into HWACondition object
//    }];
//}

- (RACSignal *) fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Use the generic fetch method and map results to convert into an array of Mantle objects
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        // Build a sequence from the list of raw JSON
        RACSequence *list = [json[@"list"] rac_sequence];
        
        // Use a function to map results from JSON to Mantle objects
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[HWADailyForecast class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}



@end
