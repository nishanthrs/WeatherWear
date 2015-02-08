//
//  HWAClothes.m
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/8/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "HWAClothes.h"
#import "HWACondition.h"

@implementation HWAClothes

- (id) init {
    self = [self initWithData: nil andImage: nil];
    return self;
}

- (id) initWithData:(NSDictionary *)data andImage:(UIImage *)image {
    self = [super init];
    
    self.name = data[CLOTHE_NAME];
    self.shortDescription = data[CLOTHE_DESCR];
    
    self.clotheImage = image;
    
    return self;
}

@end
