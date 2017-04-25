//
//  DeviceContact.h
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeviceContact : NSObject

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSArray<NSString *> * phoneNumbers;
@property (nonatomic, readonly) NSArray<NSString *>  * emailAddresses;

- (instancetype) initWithCNContact: (CNContact *) cNContact;
- (instancetype) initWithWithFullName:(NSString *) fullName phoneNumbers:(NSArray<NSString *> *) phoneNumbers emails:(NSArray<NSString *>*) emails;

@end
