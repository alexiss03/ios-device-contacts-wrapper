//
//  CNContactPermissionHelper.m
//  Contacts
//
//  Created by Hanet on 4/24/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

#import "CNContactPermissionHelper.h"
#import "CNContactConstants.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation CNContactPermissionHelper

+ (void) requestContactPermissionCompletionHandler:(void(^)(BOOL authorized, NSError * error)) completionHandler
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self requestContactPermissioniOS9AboveCompletionHandler:completionHandler];
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self requestContactPermissioniOS8CompletionHandler:completionHandler];
    }
}

+ (void) requestContactPermissioniOS8CompletionHandler:(void(^)(BOOL authorized, NSError * error)) completionHandler
{
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
             if (granted) {
                 completionHandler(granted, NULL);
             }
             else {
                 completionHandler(NO, [self permissionDeniedError]);
             }
             CFRelease(addressBook);
         });
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
        NSLog(@"Contact permission is restricted.");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        completionHandler(NO, [self permissionDeniedError]);
        NSLog(@"Contact permission is denied.");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        completionHandler(YES, NULL);
    }
}

+ (void) requestContactPermissioniOS9AboveCompletionHandler:(void(^)(BOOL authorized, NSError * error)) completionHandler
{
    CNContactStore * contactStore = [[CNContactStore alloc]init];
    
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        NSLog(@"Contact permission is not determined.");
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
            if(granted) {
                completionHandler(granted, NULL);
            }
            else {
                completionHandler(NO, [self permissionDeniedError]);
            }
        }];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusRestricted) {
        NSLog(@"Contact permission is restricted.");
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusDenied) {
        completionHandler(NO, [self permissionDeniedError]);
        NSLog(@"Contact permission is denied.");
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        NSLog(@"Contact permission is authorized.");
        completionHandler(YES, NULL);
    }
}


+ (NSError *) permissionDeniedError
{
    NSError * permissionDeniedError = [[NSError alloc] initWithDomain:CONTACTS_DOMAIN_ERROR code:CNContactPermissionDeniedError userInfo:nil];
    return permissionDeniedError;
}

@end
