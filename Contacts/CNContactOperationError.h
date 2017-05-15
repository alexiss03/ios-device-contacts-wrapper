//
//  CNOperationErrorFactory.h
//  Contacts
//
//  Created by Hanet on 5/15/17.
//  Copyright © 2017 Hanet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNContactOperationError : NSObject

+ (NSError *) permissionDenied;
+ (NSError *) permissionRestricted;
+ (NSError *) importingFromFramework;

@end
