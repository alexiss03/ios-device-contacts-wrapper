//
//  CNLoadContactsOperation.m
//  Contacts
//
//  Created by Hanet on 5/12/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

#import "CNContactsImportOperation.h"
#import "CNContactOperationError.h"
#import "DeviceContact.h"

@interface CNContactsImportOperation()

@property (strong, nonatomic) NSArray<DeviceContact *> * contacts;

@end

@implementation CNContactsImportOperation

- (void) execute
{
    [self loadContacts];
}

- (void)loadContacts
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNContactStore * contactStore = [[CNContactStore alloc] init];
        [self loadContactsWithContactStore:contactStore];
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        [self loadContactsWithAddressBook:addressBook];
    }
}

- (void) loadContactsWithContactStore:(CNContactStore *) contactStore
{
    [self getContactsIOS9Above:contactStore];
}

- (void) loadContactsWithAddressBook:(ABAddressBookRef) addressBook
{
    [self getContactsIOS8:addressBook];
}


- (void) getContactsIOS8: (ABAddressBookRef) addressBook
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
    
    self.contacts = contactList;
    [self finish];
}


- (void) getContactsIOS9Above:(CNContactStore *) contactStore
{
    NSArray * keysToFetch = @[[CNContactFormatter descriptorForRequiredKeysForStyle: CNContactFormatterStyleFullName], CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactIdentifierKey];
    NSError * error;
    NSArray * allContainers  = [contactStore containersMatchingPredicate:nil error:&error];
    NSMutableArray * retrievedContacts = [[NSMutableArray alloc] init];
    
    if (error) {
        NSLog(@"Error in getting contacts iOS 9 & iOS 10: %@", error.description);
        [self finishWithError:[CNContactOperationError importingFromFramework]];
        return;
    }
    
    for(CNContainer * container in allContainers) {
        NSError * error;
        
        NSPredicate * fetchPredicate = [CNContact predicateForContactsInContainerWithIdentifier:[container identifier]];
        NSArray * containerResults = [contactStore unifiedContactsMatchingPredicate:fetchPredicate keysToFetch:keysToFetch error: &error];
        
        [retrievedContacts addObjectsFromArray:containerResults];
        
        if(error) {
            NSLog(@"Error in getting contacts iOS 9 & iOS 10: %@", error.description);
            [self finishWithError:[CNContactOperationError importingFromFramework]];
            return;
        }
    }
    
    NSMutableArray<DeviceContact *> * contactList = [[NSMutableArray alloc] init];
    
    for(CNContact * cNContact in retrievedContacts) {
        DeviceContact * deviceContact = [[DeviceContact alloc] initWithCNContact:cNContact];
        [contactList addObject:deviceContact];
    }
    
    self.contacts = contactList;
    [self finish];
}


#pragma mark - INSChainableOperationProtocol Methods
- (void)chainedOperation:(nonnull NSOperation *)operation didFinishWithErrors:(nullable NSArray <NSError *>*)errors passingAdditionalData:(nullable id)data
{
    
}

- (nullable id) additionalDataToPassForChainedOperation
{
    return self.contacts;
}

@end
