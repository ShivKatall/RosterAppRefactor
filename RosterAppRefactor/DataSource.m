//
//  DataSource.m
//  RosterAppRefactor
//
//  Created by Cole Bratcher on 4/12/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "DataSource.h"
#import "Person.h"
#import "PersonCell.h"

#define studentPListPath [[DataSource applicationDocumentsDirectory] stringByAppendingPathComponent:@"Students.plist" ]
#define teacherPListPath [[DataSource applicationDocumentsDirectory] stringByAppendingPathComponent:@"Teachers.plist"]

@implementation DataSource

+(DataSource *)sharedData {
    static dispatch_once_t pred;
    static DataSource *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[DataSource alloc] initWithStudentsAndTeachers];
        
    });
    return shared;
}


- (void)save
{
    [NSKeyedArchiver archiveRootObject:self.teacherList toFile:teacherPListPath];
    
    [NSKeyedArchiver archiveRootObject:self.studentList toFile:studentPListPath];
}

-(instancetype)initWithStudentsAndTeachers
{
    self = [super init];
    
    self.studentList = [[NSMutableArray alloc] init];
    self.teacherList = [[NSMutableArray alloc] init];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:studentPListPath]){
        self.studentList = [NSKeyedUnarchiver unarchiveObjectWithFile:studentPListPath];
        self.teacherList = [NSKeyedUnarchiver unarchiveObjectWithFile:teacherPListPath];
    } else {
        NSString *pListBundlePath = [[NSBundle mainBundle] pathForResource:@"PeopleRoster" ofType:@"plist"];
        NSDictionary *rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:pListBundlePath];
        
        NSMutableArray *tempTeacherArray = [rootDictionary objectForKey:@"Teachers"];
        NSMutableArray *tempStudentArray = [rootDictionary objectForKey:@"Students"];
        
        for (NSDictionary *studentDictionary in tempStudentArray) {
            Person *student = [[Person alloc] init];
            student.firstName = [studentDictionary objectForKey:@"firstName"];
            student.lastName = [studentDictionary objectForKey:@"lastName"];
            
            [self.studentList addObject:student];
        }
        
        for (NSDictionary *teacherDictionary in tempTeacherArray) {
            Person *teacher = [[Person alloc] init];
            teacher.firstName = [teacherDictionary objectForKey:@"firstName"];
            teacher.lastName = [teacherDictionary objectForKey:@"lastName"];
            
            [self.teacherList addObject:teacher];
        }
        
        [self save];
    }
    
    
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)sortByLastName
{
    NSSortDescriptor *lastNameSortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"lastName" ascending:YES selector:@selector(localizedStandardCompare:)];
    
    self.teacherList = [[self.teacherList sortedArrayUsingDescriptors:@[lastNameSortDescriptor]]mutableCopy];
    self.studentList = [[self.studentList sortedArrayUsingDescriptors:@[lastNameSortDescriptor]]mutableCopy];
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return self.teacherList.count;
    } else {
        return self.studentList.count;
    }
}

+(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}


-(PersonCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
        Person *person = [self.teacherList objectAtIndex:indexPath.row];
        cell.personLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName ];
        cell.personImageView.layer.cornerRadius = 22;
        cell.personImageView.layer.masksToBounds = YES;
        cell.personImageView.image = person.avatar;
        return cell;
    } else
    {
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
        Person *person = [self.studentList objectAtIndex:indexPath.row];
        cell.personLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName ];
        cell.personImageView.layer.cornerRadius = 22;
        cell.personImageView.layer.masksToBounds = YES;
        cell.personImageView.image = person.avatar;
        return cell;
    }
}

@end
