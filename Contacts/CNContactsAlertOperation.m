//
//  CNContactsAlertOperation.m
//  Contacts
//
//  Created by Hanet on 5/15/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import "CNContactsAlertOperation.h"
#import "CNContactConstants.h"

@interface CNContactsAlertOperation()

@property (strong, nonatomic, nonnull) NSError * error;
@property (strong, nonatomic, nonnull) UIViewController * presentationContext;

@end

@implementation CNContactsAlertOperation

- (instancetype) initWithPresentationContext:(UIViewController *) presentationContext withError:(NSError *) error
{
    self = [super init];
    if(self) {
        _presentationContext = presentationContext;
        _error = error;
    }
    return self;
}

- (void) execute
{
    NSParameterAssert(self.presentationContext);
    NSParameterAssert(self.error);
    
    [self generateAlertFromError:self.error];
}

- (UIAlertController *) generateAlertFromError:(NSError *) error
{
    if([error.domain isEqualToString:CONTACTS_DOMAIN_ERROR] && (error.code == CNContactPermissionDeniedError || error.code == CNContactPermissionRestrictedError)) {
        UIAlertController * alertController = [self permissionDeniedErrorAlert];
        [self.presentationContext presentViewController:alertController animated:YES completion:nil];
    }
    
    return nil;
}

- (UIAlertController *) permissionDeniedErrorAlert
{
    NSString * localizedTitle = NSLocalizedStringWithDefaultValue(@"permission.contacts.denied.title", nil, [NSBundle mainBundle], @"Contacts Permission Denied", @"Title of the Permission Denied in Contacts Permission");
    NSString * localizedBody = NSLocalizedStringWithDefaultValue(@"permission.contacts.denied.body", nil, [NSBundle mainBundle], @"Access to Contacts is disabled. Please enable to sync your device's contacts", @"Body of the Permission Denied in Contacts Permission");
    NSString * localizedOK = NSLocalizedStringWithDefaultValue(@"permission.contacts.ok", nil, [NSBundle mainBundle], @"OK", @"Ok button");
    NSString * localizedCancel = NSLocalizedStringWithDefaultValue(@"permission.contacts.cancel", nil, [NSBundle mainBundle], @"Cancel", @"Cancel button");
    
    UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:localizedTitle message:localizedBody preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okButton = [UIAlertAction actionWithTitle:localizedOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url;
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            url = [NSURL URLWithString:@"App-Prefs:root=Privacy&path=CONTACTS"];
        }
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        
        [self finish];
    }];
    
    UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:localizedCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self finish];
    }];
    
    [errorAlert addAction: okButton];
    [errorAlert addAction: cancelButton];
    return errorAlert;
}


@end
