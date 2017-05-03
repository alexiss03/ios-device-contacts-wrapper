//
//  DeviceContacts.h
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

#import "DeviceContact.h"

@protocol CNDeviceContactsInteractorProtocol <NSObject>

+ (void) loadContactsWithAddressBook:(ABAddressBookRef) addressBook contacts:(void(^)(NSArray<DeviceContact *> *)) contacts error:(void(^)(NSError *)) error;
+ (void) loadContactsWithContactStore:(CNContactStore *) contactStore contacts: (void(^)(NSArray<DeviceContact *> *)) contacts error:(void(^)(NSError *)) error;

@end

@interface CNDeviceContactsInteractor : NSObject

+ (void)loadContacts: (void (^)(NSArray<DeviceContact *> *))contacts error:(void (^)(NSError *))error;
+ (void) addNDemoNewContact;

@end
