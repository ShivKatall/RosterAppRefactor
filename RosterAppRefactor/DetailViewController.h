//
//  DetailViewController.h
//  RosterAppRefactor
//
//  Created by Cole Bratcher on 4/12/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "Person.h"

@interface DetailViewController : UIViewController

@property (nonatomic, weak) Person *person;
@property (nonatomic, weak) DataSource *dataSource;

@end
