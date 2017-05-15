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
#import "CNContactConstants.h"


@interface DeviceContact()

@property (nonatomic, readwrite) NSString * name;
@property (nonatomic, readwrite) NSString * identifier;
@property (nonatomic, readwrite) NSArray<NSString *> * mobileNumbers;
@property (nonatomic, readwrite) NSArray<NSString *>  * emailAddresses;

@end

@implementation DeviceContact

- (instancetype) initWithCNContact: (CNContact *) cNContact
{
    self = [super init];
    
    if(self) {
        _name = [NSString stringWithFormat:@"%@ %@", cNContact.givenName, cNContact.familyName];
        _identifier = cNContact.identifier;
        
        Class formatHelper = [CNContactFormatHelper class];
        _mobileNumbers = [formatHelper stringArrayFromCNLabeledValueArray:cNContact.phoneNumbers];
        _emailAddresses = [formatHelper stringArrayFromCNLabeledValueArray:cNContact.emailAddresses];

    }
    return self;
}

- (instancetype) initWithWithFullName:(NSString *) fullName identifier:(NSString *) identifier phoneNumbers:(NSArray<NSString *> *) phoneNumbers emails:(NSArray<NSString *>*) emails
{
    self = [super init];

    if(self) {
        _name = fullName;
        _identifier = identifier;
        _emailAddresses = emails;
        _mobileNumbers = phoneNumbers;
    }
    return self;
}


- (NSString *) objectHash
{
    return [CNContactFormatHelper sha256HashFor:self.name];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Name: %@ Identifier:%@ Hash: %@ PhoneNumbers: %@ Email Addresses:%@", self.name, self.identifier, self.objectHash, self.mobileNumbers, self.emailAddresses];
}

#pragma mark - MTLJSONSerializing Methods
+ (NSDictionary *) JSONKeyPathsByPropertyKey
{
    return @{@"emailAddresses": @"email_address",
             @"name": @"name",
             @"identifier": @"device_contact_id",
             @"mobileNumbers":@"mobile_number"};
}

@end
