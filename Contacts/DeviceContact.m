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
@property (nonatomic, readwrite) NSString * iOS9AboveIdentifier;
@property (nonatomic, readwrite) NSString * iOS8Identifier;
@property (nonatomic, readwrite) NSArray<NSString *> * mobileNumbers;
@property (nonatomic, readwrite) NSArray<NSString *>  * emailAddresses;

@end

@implementation DeviceContact

- (instancetype) initWithCNContact: (CNContact *) cNContact
{
    self = [super init];
    
    if(self) {
        _name = [NSString stringWithFormat:@"%@ %@", cNContact.givenName, cNContact.familyName];
        _iOS9AboveIdentifier = cNContact.identifier;
        
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
        _iOS8Identifier = identifier;
        _emailAddresses = emails;
        _mobileNumbers = phoneNumbers;
    }
    return self;
}


- (NSString *) identifier
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
        return self.iOS9AboveIdentifier;
    } else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return self.iOS8Identifier;
    }
    return nil;
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"Name: %@\n Identifier:%@ \nPhoneNumbers: %@ \nEmail Addresses:%@", self.name, self.identifier, self.mobileNumbers, self.emailAddresses];
}

- (NSDictionary *) dictionaryValue
{
    if(self.emailAddresses.count == 0 && self.mobileNumbers.count == 0) {
        return nil;
    }
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.name forKey:@"name"];
    
    if (self.emailAddresses.count > 0) {
        [dictionary setObject:self.emailAddresses forKey:@"email_address"];
    }
    
    if (self.mobileNumbers.count > 0) {
        [dictionary setObject:self.mobileNumbers forKey:@"mobile_number"];
    }
    
    
    return dictionary;
}

@end
