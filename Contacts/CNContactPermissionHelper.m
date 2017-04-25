//
//  CNContactPermissionHelper.m
//  Contacts
//
//  Created by Hanet on 4/24/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

#import "CNContactPermissionHelper.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation CNContactPermissionHelper

+ (void) requestContactPermissionCompletionHandler:(void(^)(BOOL authorized, UIAlertController * error)) completionHandler
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self requestContactPermissioniOS9AboveCompletionHandler:completionHandler];
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self requestContactPermissioniOS8CompletionHandler:completionHandler];
    }
}

+ (void) requestContactPermissioniOS8CompletionHandler:(void(^)(BOOL authorized, UIAlertController * error)) completionHandler
{
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
             if (granted) {
                 completionHandler(granted, NULL);
             }
             else {
                 completionHandler(NO, [self permissionDeniedErrorAlert]);
             }
             CFRelease(addressBook);
         });
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
        NSLog(@"Contact permission is restricted.");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        completionHandler(NO, [self permissionDeniedErrorAlert]);
        NSLog(@"Contact permission is denied.");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        completionHandler(YES, NULL);
    }
}

+ (void) requestContactPermissioniOS9AboveCompletionHandler:(void(^)(BOOL authorized, UIAlertController * error)) completionHandler
{
    CNContactStore * contactStore = [[CNContactStore alloc]init];
    
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        NSLog(@"Contact permission is not determined.");
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
            if(granted) {
                completionHandler(granted, NULL);
            }
            else {
                completionHandler(NO, [self permissionDeniedErrorAlert]);
            }
        }];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusRestricted) {
        NSLog(@"Contact permission is restricted.");
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusDenied) {
        completionHandler(NO, [self permissionDeniedErrorAlert]);
        NSLog(@"Contact permission is denied.");
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        NSLog(@"Contact permission is authorized.");
        completionHandler(YES, NULL);
    }
}


+ (UIAlertController *) permissionDeniedErrorAlert
{
    NSString * localizedTitle = NSLocalizedStringWithDefaultValue(@"contacts.permission.denied.title", nil, [NSBundle mainBundle], @"Contacts Permission Denied", @"Title of the Permission Denied in Contacts Permission");
    NSString * localizedBody = NSLocalizedStringWithDefaultValue(@"contacts.permission.denied.body", nil, [NSBundle mainBundle], @"Access to Contacts is disabled. Please enable to sync your device's contacts", @"Body of the Permission Denied in Contacts Permission");
    NSString * localizedOK = NSLocalizedStringWithDefaultValue(@"contacts.permission.ok", nil, [NSBundle mainBundle], @"OK", @"Ok button");
    NSString * localizedCancel = NSLocalizedStringWithDefaultValue(@"contacts.permission.cancel", nil, [NSBundle mainBundle], @"Cancel", @"Cancel button");
    
    UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:localizedTitle message:localizedBody preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okButton = [UIAlertAction actionWithTitle:localizedOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url;
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            url = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=CONTACTS"];
        }
           
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:localizedCancel style:UIAlertActionStyleCancel handler:nil];
    
    [errorAlert addAction: okButton];
    [errorAlert addAction: cancelButton];
    return errorAlert;
}

@end
