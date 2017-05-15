//
//  CNDeviceContactsOperationProvider.m
//  Contacts
//
//  Created by Hanet on 5/12/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import "CNDeviceContactsOperationProvider.h"

#import "CNContactsPermissionOperation.h"
#import "CNContactsAlertOperation.h"
#import "CNContactsImportOperation.h"

#import "DeviceContact.h"

@implementation CNDeviceContactsOperationProvider

+ (INSChainOperation *) allContactsWithPresentationContext:(nonnull UIViewController *) presentationContext
{
    NSParameterAssert(presentationContext);
    
    CNContactsPermissionOperation * permissionOperation = [[CNContactsPermissionOperation alloc] init];
    CNContactsImportOperation * fetchOperation = [[CNContactsImportOperation alloc] init];
                                                 
    __block INSChainOperation * chainOperation = [INSChainOperation operationWithOperations:@[permissionOperation, fetchOperation]];
    [chainOperation ins_addCompletionBlockInMainQueue:^(INSOperation *operation) {
        NSError * error = [operation.internalErrors firstObject];
        
        if(error) {
            CNContactsAlertOperation * alertOperation = [[CNContactsAlertOperation alloc] initWithPresentationContext:presentationContext withError:error];
            [chainOperation produceOperation:alertOperation];
        }
    }];
    return chainOperation;
}

@end
