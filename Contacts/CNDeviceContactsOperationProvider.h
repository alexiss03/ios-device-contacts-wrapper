//
//  CNDeviceContactsOperationProvider.h
//  Contacts
//
//  Created by Hanet on 5/12/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//
#import <INSOperationsKit/INSOperationsKit.h>
#import "CNContactConstants.h"

@interface CNDeviceContactsOperationProvider : NSObject

+ (nullable INSChainOperation *) allContactsWithPresentationContext:(nonnull UIViewController *) presentationContext;

@end
