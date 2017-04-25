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
#import "CNContactNotificationListener.h"

@interface ViewController() <CNContactNotificationListenerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CNContactStore * contactStore = [[CNContactStore alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //CNContactNotificationListener * listener = [[CNContactNotificationListener alloc] initWitAddressBook:addressBook delegate:self];
    //CNContactNotificationListener * listener = [[CNContactNotificationListener alloc] initWithContactStore:contactStore delegate: self];
    //[listener startListening];
    
//    [CNDeviceContactsInteractor loadContactsWithContactStore:contactStore contacts:^(NSArray<DeviceContact *> * contacts) {
//        
//    } error:^(UIAlertController * errorAlert) {
//        [self presentViewController:errorAlert animated:YES completion:nil];
//    }];
    
    [CNDeviceContactsInteractor loadContactsWithAddressBook:addressBook contacts:^(NSArray<DeviceContact *> * contacts) {
        NSLog(@"contacts:%@",contacts);
    } error:^(UIAlertController * errorAlert) {
        [self presentViewController:errorAlert animated:YES completion:nil];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CNContactNotificationListenerDelegate

- (void) contactsDidChange:(NSArray<DeviceContact *> *) contacts
{
     NSLog(@"Contacts:%@",contacts);
}

@end
