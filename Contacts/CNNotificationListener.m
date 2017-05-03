//
//  CNContactNotificationListener.m
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Contacts/Contacts.h>
#import "CNContactConstants.h"
#import "CNNotificationListener.h"

#import "CNDeviceContactsInteractor.h"

@interface CNNotificationListener()

@property (nonatomic, strong, readwrite) NSArray<DeviceContact *> * contacts;
@property (nonatomic, strong) CNContactStore * contactStore;
@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, weak) id<CNNotificationListenerDelegate> delegate;

@end

@implementation CNNotificationListener


- (instancetype) initWithDelegate:(id<CNNotificationListenerDelegate>) delegate
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        return [self initWithContactStore:[[CNContactStore alloc] init] delegate:delegate];
    } else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return [self initWitAddressBook:ABAddressBookCreateWithOptions(NULL, NULL) delegate:delegate];
    }
    
    return nil;
}


- (instancetype) initWithContactStore:(CNContactStore *) contactStore delegate:(id<CNNotificationListenerDelegate>) delegate
{
    self = [super init];
    
    if(self) {
        _contactStore = contactStore;
        _delegate = delegate;
    }
    
    return self;
}

- (instancetype) initWitAddressBook:(ABAddressBookRef) addressBook delegate:(id<CNNotificationListenerDelegate>) delegate
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
    
    __weak CNNotificationListener * weakSelf = (__bridge CNNotificationListener *)context;
    
    id<CNDeviceContactsInteractorProtocol> contactsInteractor = (id<CNDeviceContactsInteractorProtocol>)[CNDeviceContactsInteractor self];

    [contactsInteractor loadContactsWithAddressBook:weakSelf.addressBook contacts:^(NSArray<DeviceContact *> * contacts) {
        __strong CNNotificationListener * strongSelf = weakSelf;
        [strongSelf.delegate contactsDidChange:contacts];
    } error: nil];
}

- (void) stopListening
{
    self.contacts = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) contactStoreDidChange: (NSNotification *) notification
{
    NSLog(@"iOS 9 10 Address book did change");
    
    __weak CNNotificationListener * weakSelf = self;
    
    id<CNDeviceContactsInteractorProtocol> contactsInteractor = (id<CNDeviceContactsInteractorProtocol>)[CNDeviceContactsInteractor self];
    
    [contactsInteractor loadContactsWithContactStore:self.contactStore contacts:^(NSArray<DeviceContact *> * contacts) {
        __strong CNNotificationListener * strongSelf = weakSelf;
        [strongSelf.delegate contactsDidChange:contacts];
    } error:^(NSError * error) {
    
    }];
}

@end
