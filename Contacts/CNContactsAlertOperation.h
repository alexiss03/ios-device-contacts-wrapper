//
//  CNContactsAlertOperation.h
//  Contacts
//
//  Created by Hanet on 5/15/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <INSOperationsKit/INSOperationsKit.h>

@interface CNContactsAlertOperation : INSOperation

- (instancetype) initWithPresentationContext:(UIViewController *) presentationContext withError:(NSError *) error;

@end
