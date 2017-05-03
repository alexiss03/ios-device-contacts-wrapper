//
//  CNContactErrorAlertGenerator.m
//  Contacts
//
//  Created by Hanet on 5/3/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import "CNContactErrorAlertGenerator.h"
#import "CNContactConstants.h"

@implementation CNContactErrorAlertGenerator


+ (UIAlertController *) generateAlertFromError:(NSError *) error
{
    if([error.domain isEqualToString:@"com.contacts.permission"]) {
        if(error.code == CNContactPermissionDeniedError) {
            return [self permissionDeniedErrorAlert];
        }
    }
    
    return nil;
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
