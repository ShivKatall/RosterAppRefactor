//
//  Person.m
//  RosterAppRefactor
//
//  Created by Cole Bratcher on 4/12/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "Person.h"

@implementation Person

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.avatar = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
        self.twitter = [aDecoder decodeObjectForKey:@"twitter"];
        self.github = [aDecoder decodeObjectForKey:@"github"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.avatar) forKey:@"image"];
    [aCoder encodeObject:self.twitter forKey:@"twitter"];
    [aCoder encodeObject:self.github forKey:@"github"];
    
}

@end
