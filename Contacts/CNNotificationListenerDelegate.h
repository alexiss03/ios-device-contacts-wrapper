//
//  CNContactNotificationListenerDelegate.h
//  Contacts
//
//  Created by Hanet on 4/24/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

@protocol CNNotificationListenerDelegate <NSObject>

- (void) contactsDidChange:(NSArray<DeviceContact *> *) contacts;

@end
