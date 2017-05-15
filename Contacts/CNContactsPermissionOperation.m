//
//  CNContactsPermissionOperation.m
//  Contacts
//
//  Created by Hanet on 5/12/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

#import "CNContactsPermissionOperation.h"
#import "CNContactOperationError.h"

@interface CNContactsPermissionOperation ()

@end
 

@implementation CNContactsPermissionOperation

- (void) execute
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self requestContactPermissioniOS9Above];
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self requestContactPermissioniOS8];
    }
}

- (void) requestContactPermissioniOS8
{
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self finish];
            }
            else {
                [self finishWithError:[CNContactOperationError permissionDenied]];
            }
            CFRelease(addressBook);
        });
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
        NSLog(@"Contact permission is restricted.");
        [self finishWithError:[CNContactOperationError permissionRestricted]];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        NSLog(@"Contact permission is denied.");
        [self finishWithError:[CNContactOperationError permissionDenied]];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self finish];
    }
}

- (void) requestContactPermissioniOS9Above
{
    CNContactStore * contactStore = [[CNContactStore alloc]init];
    
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        NSLog(@"Contact permission is not determined.");
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
            if(granted) {
                [self finish];
            }
            else {
                [self finishWithError:[CNContactOperationError permissionDenied]];
            }
        }];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusRestricted) {
        [self finishWithError:[CNContactOperationError permissionRestricted]];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusDenied) {
        [self finishWithError:[CNContactOperationError permissionDenied]];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        NSLog(@"Contact permission is authorized.");
        [self finish];
    }
}

#pragma mark - Operation Errors

@end
