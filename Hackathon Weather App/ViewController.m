//
//  ViewController.m
//  Hackathon Weather App
//
//  Created by Nishanth Salinamakki on 2/6/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "ViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "HWAManager.h"
#import "HWAClothes.h"

@interface ViewController ()

@property (strong, nonatomic) NSDateFormatter *hourlyFormatter;
@property (strong, nonatomic) NSDateFormatter *dailyFormatter;

@end

@implementation ViewController

//Creating view by code (not hooking up to storyboard)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Gets and stores the device screen height in self.screenHeight to display weather data in paged manner
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImage *background = [UIImage imageNamed: @"background.png"];
    
    //Creates a static image background and adds it to the self.backgroundImageView
    self.backgroundImageView = [[UIImageView alloc] initWithImage: background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview: self.backgroundImageView];
    
    //Uses LBBlurredImage to create a blurred background image and sets alpha to 0 (in order to show self.backgroundImageView)
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur: background blurRadius: 10 completionBlock: nil];
    [self.view addSubview: self.blurredImageView];
    
    //Creates tableView to display all weather data
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite: 1 alpha: .2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview: self.tableView];
    
    //Sets header of table to be same size of screen
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    //Creates padding so that labels are evenly spaced
    CGFloat inset = 20;
    
    //Initialize height variables for various views
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    //Creates frames for labels and icon views based on padding and height variables
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - (hiloHeight * 2), headerFrame.size.width - (2 * inset), temperatureHeight);
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - (temperatureHeight + hiloHeight), headerFrame.size.width - (2 * inset), temperatureHeight);
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    
    //Copies iconFrame and adjusts it to expand text and moves to right of icon
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    //Sets a table header
    UIView *header = [[UIView alloc] initWithFrame: headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    //All labels of temperature, city, etc created with code
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame: temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor colorWithRed: .6 green: .2 blue: 1.0 alpha: 1.0];
    temperatureLabel.text = @"0";
    temperatureLabel.font = [UIFont fontWithName: @"AvenirNextCondensed-Regular" size: 100];
    [header addSubview: temperatureLabel];
    
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame: hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor colorWithRed: .6 green: .2 blue: 1.0 alpha: 1.0];
    hiloLabel.text = @"0 / 0";
    hiloLabel.font = [UIFont fontWithName: @"AvenirNextCondensed-Regular" size: 28];
    [header addSubview: hiloLabel];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor colorWithRed: .6 green: .2 blue: 1.0 alpha: 1.0];
    cityLabel.text = @"Loading ... ";
    cityLabel.font = [UIFont fontWithName: @"AvenirNextCondensed-Bold" size: 30];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview: cityLabel];
    
    self.conditionLabel = [[UILabel alloc] initWithFrame: conditionsFrame];
    self.conditionLabel.backgroundColor = [UIColor clearColor];
    self.conditionLabel.font = [UIFont fontWithName: @"AvenirNextCondensed-Heavy" size: 18];
    self.conditionLabel.textColor = [UIColor colorWithRed: .6 green: .2 blue: 1.0 alpha: 1.0];
    self.conditionLabel.text = @"Clear";
    [header addSubview: self.conditionLabel];
    
    //Adds image view for weather icon
    UIImageView *iconView = [[UIImageView alloc] initWithFrame: iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed: @"weather-clear.png"];
    [header addSubview: iconView];
    
    [[RACObserve([HWAManager sharedManager], currentCondition)
      deliverOn: RACScheduler.mainThreadScheduler]
     subscribeNext: ^(HWACondition *newCondition) {
         temperatureLabel.text = [NSString stringWithFormat: @"%.0f°", newCondition.temperature.floatValue];
         self.conditionLabel.text = [newCondition.condition capitalizedString];
         cityLabel.text = [newCondition.locationName capitalizedString];
         
         iconView.image = [UIImage imageNamed: [newCondition imageName]];
     }];
    
    RAC(hiloLabel, text) = [[RACSignal combineLatest: @[
                             RACObserve([HWAManager sharedManager], currentCondition.tempLow),
                             RACObserve([HWAManager sharedManager], currentCondition.tempHigh)]
                             
                                              reduce: ^(NSNumber *high, NSNumber *low) {
                                                  return [NSString stringWithFormat: @"%.0f° / %.0f°", high.floatValue, low.floatValue];
                                              }]
                            deliverOn:RACScheduler.mainThreadScheduler];
    
    [[HWAManager sharedManager] findCurrentLocation];
    
//    [[RACObserve([HWAManager sharedManager], hourlyForecast)
//            deliverOn: RACScheduler.mainThreadScheduler]
//     subscribeNext: ^(NSArray *newForecast) {
//         [self.tableView reloadData];
//     }];
    
    [[RACObserve([HWAManager sharedManager], dailyForecast)
            deliverOn: RACScheduler.mainThreadScheduler]
     subscribeNext: ^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
}

//Initializes data formatters only once, improving performance
- (id) init {
    if (self = [super init]) {
        _hourlyFormatter = [[NSDateFormatter alloc] init];
        _hourlyFormatter.dateFormat = @"h a";
        
        _dailyFormatter = [[NSDateFormatter alloc] init];
        _dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView { //2 sections for hourly and daily forecast
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return MIN([[HWAManager sharedManager].dailyForecast count], 6) + 1;
        //return MIN([[HWAManager sharedManager].hourlyForecast count], 6) + 1;
    }
    if (section == 1) {
        return 5;
    }
    return MIN([[HWAManager sharedManager].dailyForecast count], 6) + 1;
}

- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: CellIdentifier];
    }
    
    //Forecast cells should not be selectable
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.2];
    cell.textLabel.textColor = [UIColor colorWithRed: .6 green: .2 blue: 1.0 alpha: 1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed: .6 green: .2 blue: 1.0 alpha: 1.0];
    
    self.orderedArray = [[NSMutableArray alloc] init];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configureHeaderCell: cell title: @"Daily Forecast"];
        }
        else {
            HWACondition *weather = [HWAManager sharedManager].dailyForecast[indexPath.row - 1];
            [self configureDailyCell: cell weather: weather];
        }
//        if (indexPath.row == 0) {
//            [self configureHeaderCell: cell title: @"Hourly Forecast"];
//        }
//        else {
//            HWACondition *weather = [HWAManager sharedManager].hourlyForecast[indexPath.row - 1];
//            [self configureHourlyCell: cell weather: weather];
//        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell: cell title: @"What Should I Wear Right Now?"];
        }
        else {
            //HWACondition *weather = [HWAManager sharedManager].dailyForecast[indexPath.row - 1];
            
            //ConfigureClothingCell method
            if ([self.conditionLabel.text isEqualToString: @"Clear"]) {
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 4]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 7]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 8]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 13]];
                
                self.clothing = [self.orderedArray objectAtIndex: indexPath.row - 1];
                
                cell.textLabel.text = self.clothing[CLOTHE_NAME];
                cell.detailTextLabel.text = self.clothing[CLOTHE_DESCR];
                
                NSString *imageName = [NSString stringWithFormat: @"%@", cell.textLabel.text];
                cell.imageView.image = [UIImage imageNamed: imageName];
            }
            if ([self.conditionLabel.text isEqualToString: @"Mist"] || [self.conditionLabel.text isEqualToString: @"Clouds"]) {
                
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 1]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 5]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 8]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 12]];
                
                self.clothing = [self.orderedArray objectAtIndex: indexPath.row - 1];
                
                cell.textLabel.text = self.clothing[CLOTHE_NAME];
                cell.detailTextLabel.text = self.clothing[CLOTHE_DESCR];
                
                NSString *imageName = [NSString stringWithFormat: @"%@", cell.textLabel.text];
                cell.imageView.image = [UIImage imageNamed: imageName];
            }
            if ([self.conditionLabel.text isEqualToString: @"Thunderstorm"]) {
                
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 3]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 6]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 8]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 11]];
                
                self.clothing = [self.orderedArray objectAtIndex: indexPath.row - 1];
                
                cell.textLabel.text = self.clothing[CLOTHE_DESCR];
                cell.detailTextLabel.text = self.clothing[CLOTHE_DESCR];
                
                NSString *imageName = [NSString stringWithFormat: @"%@", cell.textLabel.text];
                cell.imageView.image = [UIImage imageNamed: imageName];
            }
            if ([self.conditionLabel.text isEqualToString: @"Rain"]) {
                
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 0]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 5]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 9]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 11]];
                
                self.clothing = [self.orderedArray objectAtIndex: indexPath.row - 1];
                
                cell.textLabel.text = self.clothing[CLOTHE_NAME];
                cell.detailTextLabel.text = self.clothing[CLOTHE_DESCR];
                
                NSString *imageName = [NSString stringWithFormat: @"%@", cell.textLabel.text];
                cell.imageView.image = [UIImage imageNamed: imageName];
            }
            if ([self.conditionLabel.text isEqualToString: @"Snow"]) {
                
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 2]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 5]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 9]];
                [self.orderedArray addObject: [[HWACondition clothingMap] objectAtIndex: 14]];
                
                self.clothing = [self.orderedArray objectAtIndex: indexPath.row - 1];
                
                cell.textLabel.text = self.clothing[CLOTHE_NAME];
                cell.detailTextLabel.text = self.clothing[CLOTHE_NAME];
                
                NSString *imageName = [NSString stringWithFormat: @"%@", cell.textLabel.text];
                cell.imageView.image = [UIImage imageNamed: imageName];
            }
            //End of ConfigureClothesCell method
            
        }
    }
    
//    self.orderedArray = [[NSMutableArray alloc] init];
//    if ([self.conditionLabel.text isEqualToString: @"Clear"]) {
//        
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 4]];
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 7]];
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 8]];
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 13]];
//        
//        self.clothing = [self.orderedArray objectAtIndex: indexPath.row + 1];
//    }
//    if ([self.conditionLabel.text isEqualToString: @"Mist"] || [self.conditionLabel.text isEqualToString: @"Clouds"]) {
//        
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 4]];
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 7]];
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 8]];
//        [self.orderedArray addObject:[[HWACondition clothingMap] objectAtIndex: 13]];
//        
//        self.clothing = [self.orderedArray objectAtIndex: indexPath.row + 1];
//        
//    }
    
    return cell;
}

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

//- (void)configureHourlyCell:(UITableViewCell *)cell weather:(HWACondition *)weather {
//    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
//    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
//    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
//    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//}

- (void)configureDailyCell:(UITableViewCell *)cell weather:(HWACondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:18];
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",weather.tempLow.floatValue,weather.tempHigh.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) configureClothingCell: (UITableViewCell *) cell weather: (HWACondition *) weather {
    
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
