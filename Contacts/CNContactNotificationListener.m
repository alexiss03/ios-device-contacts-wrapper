//
//  CNContactNotificationListener.m
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Contacts/Contacts.h>
#import "CNContactNotificationListener.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface CNContactNotificationListener()

@property (nonatomic, strong, readwrite) NSArray<DeviceContact *> * contacts;
@property (nonatomic, strong) CNContactStore * contactStore;
@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, weak) id<CNContactNotificationListenerDelegate> delegate;

@end

@implementation CNContactNotificationListener

- (instancetype) initWithContactStore:(CNContactStore *) contactStore delegate:(id<CNContactNotificationListenerDelegate>) delegate
{
    self = [super init];
    
    if(self) {
        _contactStore = contactStore;
        _delegate = delegate;
    }
    
    return self;
}

- (instancetype) initWitAddressBook:(ABAddressBookRef) addressBook delegate:(id<CNContactNotificationListenerDelegate>) delegate
{
    self = [super init];
    
    if(self) {
        _addressBook = addressBook;
        _delegate = delegate;
    }
    
    return self;
}

- (void) startListening
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactStoreDidChange:) name:CNContactStoreDidChangeNotification object:nil];
    } else {
        ABAddressBookRegisterExternalChangeCallback(self.addressBook, addressBookDidChange, (__bridge_retained  void *)self);
    }
}

void addressBookDidChange (ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    NSLog(@"iOS 8 Address book did change");
    
    __weak CNContactNotificationListener * weakSelf = (__bridge CNContactNotificationListener *)context;
    
    [CNDeviceContactsInteractor loadContactsWithAddressBook:addressBook contacts:^(NSArray<DeviceContact *> * contacts) {
        __strong CNContactNotificationListener * strongSelf = weakSelf;
        [strongSelf.delegate contactsDidChange:contacts];
    } error: nil];
}

- (void) stopListening
{
    self.contacts = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) contactStoreDidChange: (NSNotification *) notification {
    NSLog(@"iOS 9 10 Address book did change");
    
    __weak CNContactNotificationListener * weakSelf = self;
    
    [CNDeviceContactsInteractor loadContactsWithContactStore:self.contactStore contacts:^(NSArray<DeviceContact *> * contacts) {
        __strong CNContactNotificationListener * strongSelf = weakSelf;
        [strongSelf.delegate contactsDidChange:contacts];
    } error:^(UIAlertController * errorAlert) {
        
    }];
}

@end
