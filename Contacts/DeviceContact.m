//
//  DeviceContact.m
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
#import <Contacts/CNContact.h>
#import "DeviceContact.h"
#import "CNContactFormatHelper.h"

@interface DeviceContact()

@property (nonatomic, readwrite) NSString * name;
@property (nonatomic, readwrite) NSString * job;
@property (nonatomic, readwrite) UIImage * image;
@property (nonatomic, readwrite) NSArray<NSString *> * phoneNumbers;
@property (nonatomic, readwrite) NSArray<NSString *>  * emailAddresses;
@property (nonatomic, readwrite) NSArray<NSString *> * postalAddresses;
@property (nonatomic, readwrite) NSArray<NSString *> * socialProfiles;
@property (nonatomic, readwrite) NSDate * birthday;
@property (nonatomic, readwrite) NSArray * websites;
@property (nonatomic, readwrite) NSString * notes;
@property (nonatomic, readwrite) NSArray * relatedPersons;
@property (nonatomic, readwrite) NSArray * linkedRecordIDs;
@property (nonatomic, readwrite) NSDictionary * source;
@property (nonatomic, readwrite) NSArray * dates;
@property (nonatomic, readwrite) NSDictionary * recordDate;
@property (nonatomic, readwrite) NSDictionary * defaults;

@end


@implementation DeviceContact

- (instancetype) initWithCNContact: (CNContact *) cNContact
{
    self = [super init];
    
    if(self) {
        _name = [NSString stringWithFormat:@"%@ %@", cNContact.givenName, cNContact.familyName];
        
        Class formatHelper = [CNContactFormatHelper class];
        _phoneNumbers = [formatHelper stringArrayFromCNLabeledValueArray:cNContact.phoneNumbers];
        _emailAddresses = [formatHelper stringArrayFromCNLabeledValueArray:cNContact.emailAddresses];

    }
    return self;
}

- (instancetype) initWithWithFullName:(NSString *) fullName phoneNumbers:(NSArray<NSString *> *) phoneNumbers emails:(NSArray<NSString *>*) emails
{
    self = [super init];

    if(self) {
        _name = fullName;
        _emailAddresses = emails;
        _phoneNumbers = phoneNumbers;
    }
    return self;
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"Name: %@, PhoneNumbers: %@ Email Addresses:%@", self.name, self.phoneNumbers, self.emailAddresses];
}

@end
