//
//  ViewController.h
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/6/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

//All views are set up in code!

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat screenHeight; //assign is default; used for primitive and non-pointer types

@property (strong, nonatomic) UILabel *conditionLabel;

@property (strong, nonatomic) NSMutableArray *orderedArray;
@property (strong, nonatomic) NSDictionary *clothing;

@end

