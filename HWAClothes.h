//
//  HWAClothes.h
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/8/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HWAClothes : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shortDescription;

@property (strong, nonatomic) UIImage *clotheImage;

- (id) initWithData: (NSDictionary *) data andImage: (UIImage *) image;

@end
