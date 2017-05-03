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
#import "CNNotificationListenerDelegate.h"



@interface CNNotificationListener : NSObject

- (instancetype) initWithDelegate:(id<CNNotificationListenerDelegate>) delegate;

- (void) startListening;
- (void) stopListening;

@end
