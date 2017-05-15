//
//  CNOperationErrorFactory.m
//  Contacts
//
//  Created by Hanet on 5/15/17.
//  Copyright © 2017 Hanet. All rights reserved.
//

#import "CNContactOperationError.h"
#import "CNContactConstants.h"

@implementation CNContactOperationError

+ (NSError *) permissionDenied
{
    NSError * permissionDeniedError = [[NSError alloc] initWithDomain:CONTACTS_DOMAIN_ERROR code:CNContactPermissionDeniedError userInfo:nil];
    return permissionDeniedError;
}

+ (NSError *) permissionRestricted
{
    NSError * permissionDeniedError = [[NSError alloc] initWithDomain:CONTACTS_DOMAIN_ERROR code:CNContactPermissionRestrictedError userInfo:nil];
    return permissionDeniedError;
}

+ (NSError *) importingFromFramework
{
    NSError * permissionDeniedError = [[NSError alloc] initWithDomain:CONTACTS_DOMAIN_ERROR code:CNContactLoadingError userInfo:nil];
    return permissionDeniedError;
}

@end
