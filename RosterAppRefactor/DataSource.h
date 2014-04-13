//
//  DataSource.h
//  RosterAppRefactor
//
//  Created by Cole Bratcher on 4/12/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

@property (nonatomic, strong) NSMutableArray *studentList;
@property (nonatomic, strong) NSMutableArray *teacherList;

+(DataSource *)sharedData;

-(instancetype)initWithStudentsAndTeachers;
-(void)sortByLastName;
-(void)save;


@end
