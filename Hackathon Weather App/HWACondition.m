//
//  HWACondition.m
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/7/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "HWACondition.h"

@implementation HWACondition

//Creates private NSDictionary imageMap to store data in keys and objects
+ (NSDictionary *) imageMap {
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        //Maps the condition codes to an image file (key-object pairs)
        _imageMap = @{
                     @"01d" : @"weather-clear",
                     @"02d" : @"weather-few",
                     @"03d" : @"weather-few",
                     @"04d" : @"weather-broken",
                     @"09d" : @"weather-shower",
                     @"10d" : @"weather-rain",
                     @"11d" : @"weather-tstorm",
                     @"13d" : @"weather-snow",
                     @"50d" : @"weather-mist",
                     @"01n" : @"weather-moon",
                     @"02n" : @"weather-few-night",
                     @"03n" : @"weather-few-night",
                     @"04n" : @"weather-broken",
                     @"09n" : @"weather-shower",
                     @"10n" : @"weather-rain-night",
                     @"11n" : @"weather-tstorm",
                     @"13n" : @"weather-snow",
                     @"50n" : @"weather-mist",
                     };
    }
    return _imageMap;
}

//Set up JSON-model properties by creating NSDictionary (key is HWACondition property name and value (object) is keypath from JSON, even though JSON type (NSInteger) and property type (NSDate) are not the same)
+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"dt",
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
             @"conditionDescription": @"weather.description",
             @"condition": @"weather.main",
             @"icon": @"weather.icon",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed"
             };
}

+ (NSArray *) clothingMap {
    
    NSMutableArray *clothingArray = [[NSMutableArray alloc] init];
    
    NSDictionary *jacket = @{
                             CLOTHE_NAME : @"jacket",
                             CLOTHE_DESCR : @"Going to be a little rainy out there"
                             };
    
    [clothingArray addObject: jacket];
    
    NSDictionary *sweater = @{
                              CLOTHE_NAME : @"sweater",
                              CLOTHE_DESCR : @"Need warmth in that chilly weather"
                              };
    [clothingArray addObject: sweater];
    
    NSDictionary *coat = @{
                           CLOTHE_NAME : @"coat",
                           CLOTHE_DESCR : @"Perfect for snowy weather!"
                           };
    [clothingArray addObject: coat];
    
    NSDictionary *raincoat = @{
                               CLOTHE_NAME : @"raincoat",
                               CLOTHE_DESCR : @"Need that raincoat for that rain!"
                               };
    [clothingArray addObject: raincoat];
    
    NSDictionary *tshirt = @{
                             CLOTHE_NAME : @"tshirt",
                             CLOTHE_DESCR : @"Embrace the casual t-shirt today!"
                             };
    [clothingArray addObject: tshirt];
    
    NSDictionary *pants = @{
                            CLOTHE_NAME : @"pants",
                            CLOTHE_DESCR : @"Cover those legs!"
                            };
    [clothingArray addObject: pants];
    
    NSDictionary *trousers = @{
                               CLOTHE_NAME : @"trousers",
                               CLOTHE_DESCR : @"Get the waterproof ones for that rain!"
                               };
    [clothingArray addObject: trousers];
    
    NSDictionary *shorts = @{
                             CLOTHE_NAME : @"shorts",
                             CLOTHE_DESCR : @"Enjoy freely with shorts!"
                             };
    [clothingArray addObject: shorts];
    
    NSDictionary *shoes = @{
                            CLOTHE_NAME : @"shoes",
                            CLOTHE_DESCR : @"Better to wear shoes in this weather"
                            };
    [clothingArray addObject: shoes];
    
    NSDictionary *boots = @{
                            CLOTHE_NAME : @"boots",
                            CLOTHE_DESCR : @"Keep those feet nice and warm!"
                            };
    [clothingArray addObject: boots];
    
    NSDictionary *sandals = @{
                              CLOTHE_NAME : @"sandals",
                              CLOTHE_DESCR : @"Relax and enjoy in those sandals!"
                              };
    [clothingArray addObject: sandals];
    
    NSDictionary *umbrella = @{
                               CLOTHE_NAME : @"umbrella",
                               CLOTHE_DESCR : @"Useful against that rain, huh?"
                               };
    [clothingArray addObject: umbrella];
    
    NSDictionary *beanie = @{
                             CLOTHE_NAME : @"beanie",
                             CLOTHE_DESCR : @"Warm and toasty for your head!"
                             };
    [clothingArray addObject: beanie];
    
    NSDictionary *sunglasses = @{
                             CLOTHE_NAME : @"sunglasses",
                             CLOTHE_DESCR : @"Keep your eyes safe from the sun!"
                             };
    [clothingArray addObject: sunglasses];
    
    NSDictionary *gloves = @{
                             CLOTHE_NAME : @"gloves",
                             CLOTHE_DESCR : @"If you want to play in the snow ..."
                             };
    [clothingArray addObject: gloves];
    
    
//    NSDictionary *topClothing = @{
//                              @"weather-shower" : @"jacket",
//                              @"weather-mist" : @"sweater",
//                              @"weather-rain" : @"jacket",
//                              @"weather-rain-night" : @"raincoat",
//                              @"weather-snow" : @"coat",
//                              @"weather-tstorm" : @"raincoat",
//                              @"weather-clear" : @"tshirt"
//                              };
//    [clothingArray addObject: topClothing];
//    
//    NSDictionary *bottomClothing = @{
//                                    @"weather-shower" : @"sweatpants",
//                                    @"weather-mist" : @"pants",
//                                    @"weather-rain" : @"pants",
//                                    @"weather-rain-night" : @"trousers",
//                                    @"weather-snow" : @"pants",
//                                    @"weather-tstorm" : @"trousers",
//                                    @"weather-clear" : @"shorts"
//                                    };
//    
//    [clothingArray addObject: bottomClothing];
//    
//    NSDictionary *footCloting = @{
//                                  @"weather-shower" : @"shoes",
//                                  @"weather-mist" : @"shoes",
//                                  @"weather-rain" : @"boots",
//                                  @"weather-rain-night" : @"boots",
//                                  @"weather-snow" : @"snowboots",
//                                  @"weather-tstorm" : @"boots",
//                                  @"weather-clear" : @"sandals"
//                                  };
//    [clothingArray addObject: footCloting];
//    
//    NSDictionary *additionalClothing = @{
//                                         @"weather-shower" : @"umbrella",
//                                         @"weather-mist" : @"beanie",
//                                         @"weather-rain" : @"umbrella",
//                                         @"weather-rain-night" : @"umbrella",
//                                         @"weather-snow" : @"gloves",
//                                         @"weather-tstorm" : @"umbrella",
//                                         @"weather-clear" : @"sunglasses"
//                                         };
//    [clothingArray addObject: additionalClothing];
    
    return [clothingArray copy];
}

#pragma mark - Methods to convert various data to Obj-C properties or useful information

//Transformer methods to resolve JSON and property type disparity (uses blocks: private methods to create values)
//Converts from Unix time (JSON) to NSDate (Obj-C Property)
+ (NSValueTransformer *) dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *string) {
        return [NSDate dateWithTimeIntervalSince1970: string.floatValue];
    } reverseBlock: ^(NSDate *date) {
        return [NSString stringWithFormat: @"%f", [date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *) sunriseJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *) sunsetJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *) conditionDescriptionJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock: ^(NSArray *values) {
        return [values firstObject];
    } reverseBlock: ^(NSString *string) {
        return @[string];
    }];
}

+ (NSValueTransformer *) conditionJSONTransformer {
    return [self conditionDescriptionJSONTransformer];
}

+ (NSValueTransformer *) iconJSONTransformer {
    return [self conditionDescriptionJSONTransformer];
}

#define MPS_MPH 2.23694f

+ (NSValueTransformer *) windSpeedJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock: ^(NSNumber *number) {
        return @(number.floatValue*MPS_MPH);
    } reverseBlock: ^(NSNumber *speed) {
        return @(speed.floatValue/MPS_MPH);
    }];
}

//Gets an image file name by declaring pub
- (NSString *) imageName {
    return [HWACondition imageMap][self.icon];
}

- (NSString *) clothingImageName {
    return [[HWACondition clothingMap] objectAtIndex: (int) self.icon];
}

@end
