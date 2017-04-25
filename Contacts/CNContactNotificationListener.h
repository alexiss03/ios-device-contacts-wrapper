//
//  CNContactNotificationListener.h
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

#import "CNDeviceContactsInteractor.h"
#import "CNContactNotificationListenerDelegate.h"


@interface CNContactNotificationListener : NSObject

- (instancetype) initWithContactStore:(CNContactStore *) contactStore delegate:(id<CNContactNotificationListenerDelegate>) delegate;
- (instancetype) initWitAddressBook:(ABAddressBookRef) addressBook delegate:(id<CNContactNotificationListenerDelegate>) delegate;

- (void) startListening;
- (void) stopListening;

@end
