//
//  ViewController.m
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Contacts/Contacts.h>

#import "ViewController.h"
#import "CNDeviceContactsInteractor.h"
#import "CNContactErrorAlertGenerator.h"

#import "CNNotificationListener.h"

@interface ViewController()<CNNotificationListenerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    CNNotificationListener * listener = [[CNNotificationListener alloc] initWithDelegate:self];
    [listener startListening];
    [CNDeviceContactsInteractor addNDemoNewContact];
    
    [listener stopListening];
    
    [CNDeviceContactsInteractor loadContacts:^(NSArray<DeviceContact *> * contacts) {
        NSLog(@"Contacts: %@", contacts);
    } error:^(NSError * error) {
        NSLog(@"Error: %@", error);
        UIAlertController * errorAlert = [CNContactErrorAlertGenerator generateAlertFromError:error];
        if(errorAlert) {
            [self presentViewController:errorAlert animated:true completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CNContactNotificationListenerDelegate

- (void) contactsDidChange:(NSArray<DeviceContact *> *) contacts
{
     NSLog(@"Reloaded contacts:%@",contacts);
}

@end
