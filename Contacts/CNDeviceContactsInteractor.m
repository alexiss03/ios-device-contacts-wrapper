//
//  DeviceContacts.m
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import "CNDeviceContactsInteractor.h"
#import "CNContactPermissionHelper.h"
#import "CNContactConstants.h"

@interface CNDeviceContactsInteractor()<CNDeviceContactsInteractorProtocol>

@end

@implementation CNDeviceContactsInteractor

+ (void) addNDemoNewContact
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self addNewContactiOS9Above];
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        [self addNewContactiOS8];
    }
}

+ (void) addNewContactiOS9Above
{
    CNContactStore * store = [[CNContactStore alloc] init];
    
    CNMutableContact * newContact = [[CNMutableContact alloc] init];
    [newContact setGivenName:@"Darth"];
    [newContact setFamilyName:@"Vader"];
    
    CNLabeledValue * phone = [[CNLabeledValue alloc] initWithLabel:CNLabelHome value:[[CNPhoneNumber alloc] initWithStringValue:@"09191234567"]];
    newContact.phoneNumbers = @[phone];
    
    NSError * error;
    CNSaveRequest * saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:newContact toContainerWithIdentifier:nil];
    [store executeSaveRequest:saveRequest error:&error];
    
    if (error) {
        NSLog(@"Error in saving new contact: %@",error.description);
    }
}

+ (void) addNewContactiOS8
{
    NSString * firstName = @"Anakin";
    NSString * lastName = @"Skywalker";
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef pet = ABPersonCreate();
    
    ABRecordSetValue(pet, kABPersonFirstNameProperty, (__bridge CFStringRef)firstName, nil);
    ABRecordSetValue(pet, kABPersonLastNameProperty, (__bridge CFStringRef)lastName, nil);
    
    NSString * phoneNumber = @"09196582619";
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)phoneNumber, kABPersonPhoneMainLabel, NULL);
    ABAddressBookAddRecord(addressBookRef, pet, nil);
    ABAddressBookSave(addressBookRef, nil);

}

+ (void)loadContacts: (void (^)(NSArray<DeviceContact *> *))contacts error:(void (^)(NSError *))error
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNContactStore * contactStore = [[CNContactStore alloc] init];
        [CNDeviceContactsInteractor loadContactsWithContactStore:contactStore contacts:^(NSArray<DeviceContact *> * deviceContacts) {
            //NSLog(@"contacts:%@",contacts);
            contacts(deviceContacts);
        } error:^(NSError * nserror) {
            error(nserror);
        }];
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        [CNDeviceContactsInteractor loadContactsWithAddressBook:addressBook contacts:^(NSArray<DeviceContact *> * deviceContacts) {
            //NSLog(@"contacts:%@",contacts);
            contacts(deviceContacts);
        } error:^(NSError * nserror) {
            error(nserror);
        }];
    }
}

+ (void) loadContactsWithContactStore:(CNContactStore *) contactStore contacts: (void(^)(NSArray<DeviceContact *> *)) contacts error:(void(^)(NSError *)) error
{
    [CNContactPermissionHelper requestContactPermissionCompletionHandler:^(BOOL authorized, NSError * nserror) {
        if(authorized) {
            [self getContactsIOS9Above:contactStore contacts:contacts];
        } else {
            error(nserror);
        }
    }];
    
}

+ (void) loadContactsWithAddressBook:(ABAddressBookRef) addressBook contacts:(void(^)(NSArray<DeviceContact *> *)) contacts error:(void(^)(NSError *)) error
{
    [CNContactPermissionHelper requestContactPermissionCompletionHandler:^(BOOL authorized, NSError * nserror) {
        if(authorized) {
            [self getContactsIOS8:addressBook contacts: contacts];
        } else {
            error(nserror);
        }
    }];
}


+ (void) getContactsIOS8: (ABAddressBookRef) addressBook contacts:(void(^)(NSArray<DeviceContact *> *)) contacts
{
    NSMutableArray * contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int iterator = 0; iterator < nPeople; iterator++) {
        ABRecordRef contact = CFArrayGetValueAtIndex(allPeople, iterator);

        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(contact, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(contact, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(contact, kABPersonLastNameProperty);
        NSString * fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        NSString * identifier = [NSString stringWithFormat:@"%i", ABRecordGetRecordID(contact)];

        NSMutableArray * emails = [[NSMutableArray alloc] init];
        ABMutableMultiValueRef email  = ABRecordCopyValue(contact, kABPersonEmailProperty);
        for (int iterator = 0; iterator < ABMultiValueGetCount(email); iterator++) {
            [emails addObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(email, iterator)];
        }
        
        NSMutableArray * phoneNumbers = [[NSMutableArray alloc] init];
        NSString * mobileLabel;
        
        for(CFIndex iterator = 0; iterator < ABMultiValueGetCount(phones); iterator++) {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, iterator);
            [phoneNumbers addObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, iterator)];
        }
        
        [contactList addObject:[[DeviceContact alloc] initWithWithFullName:fullName identifier:identifier phoneNumbers:phoneNumbers emails:emails]];
    }
    
    contacts(contactList);
}


+ (void) getContactsIOS9Above:(CNContactStore *) contactStore contacts:(void(^)(NSArray<DeviceContact *> *)) contacts
{
    NSArray * keysToFetch = @[[CNContactFormatter descriptorForRequiredKeysForStyle: CNContactFormatterStyleFullName],
                              CNContactEmailAddressesKey,
                              CNContactPhoneNumbersKey,
                              CNContactIdentifierKey];
    NSError * error;
    NSArray * allContainers  = [contactStore containersMatchingPredicate:nil error:&error];
    NSMutableArray * retrievedContacts = [[NSMutableArray alloc] init];
   
    if (error) {
        NSLog(@"Error in getting contacts iOS 9 & iOS 10: %@", error.description);
    }
    
    for(CNContainer * container in allContainers) {
        NSError * error;
        
        NSPredicate * fetchPredicate = [CNContact predicateForContactsInContainerWithIdentifier:[container identifier]];
        NSArray * containerResults = [contactStore unifiedContactsMatchingPredicate:fetchPredicate keysToFetch:keysToFetch error: &error];
        
        [retrievedContacts addObjectsFromArray:containerResults];
        
        if(error) {
            NSLog(@"Error in getting contacts iOS 9 & iOS 10: %@", error.description);
        }
    }
    
    NSMutableArray<DeviceContact *> * cNContactsArray = [[NSMutableArray alloc] init];
    
    for(CNContact * cNContact in retrievedContacts) {
        DeviceContact * deviceContact = [[DeviceContact alloc] initWithCNContact:cNContact];
        [cNContactsArray addObject:deviceContact];
    }
    
    contacts(cNContactsArray);
}

@end
