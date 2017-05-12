//
//  DeviceContact.h
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>

@interface DeviceContact : MTLModel

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * identifier;
//@property (nonatomic, readonly) NSString * objectHash;
@property (nonatomic, readonly) NSArray<NSString *> * mobileNumbers;
@property (nonatomic, readonly) NSArray<NSString *>  * emailAddresses;

- (instancetype) initWithCNContact: (CNContact *) cNContact;
- (instancetype) initWithWithFullName:(NSString *) fullName identifier:(NSString *) identifier phoneNumbers:(NSArray<NSString *> *) phoneNumbers emails:(NSArray<NSString *>*) emails;

@end
