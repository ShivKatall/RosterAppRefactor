//
//  RosterAppViewController.m
//  RosterAppRefactor
//
//  Created by Cole Bratcher on 4/12/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//


#import "RosterAppViewController.h"
#import "Person.h"
#import "DetailViewController.h"
#import "PersonCell.h"
#import "DataSource.h"

@interface RosterAppViewController ()

@property (weak, nonatomic) IBOutlet UITableView *rosterTableView;
@property (strong, nonatomic) DataSource *dataSource;
@end

@implementation RosterAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource = [DataSource sharedData];
    
    self.rosterTableView.dataSource = _dataSource;
    self.rosterTableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_dataSource sortByLastName];
    [self.rosterTableView reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.rosterTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        DetailViewController *destination = segue.destinationViewController;
        destination.dataSource = self.dataSource;
        if (indexPath.section == 0) {
            destination.person = [_dataSource.teacherList objectAtIndex:[self.rosterTableView indexPathForSelectedRow].row];
        } else {
            destination.person = [_dataSource.studentList objectAtIndex:[self.rosterTableView indexPathForSelectedRow].row];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Teachers";
    } else {
        return @"Students";
    }
}

#pragma mark - UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
