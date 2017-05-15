//
//  CNContactConstants.h
//  Contacts
//
//  Created by Hanet on 5/3/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceContact.h"

@interface CNContactConstants : NSObject

enum CNContactError {
    CNContactPermissionDeniedError = 1000,
    CNContactPermissionRestrictedError = 2000,
    CNContactLoadingError = 3000
};

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define CONTACTS_DOMAIN_ERROR @"contacts.loading" 

@end
