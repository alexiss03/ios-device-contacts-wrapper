//
//  CNContactFormatHelper.m
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Contacts/Contacts.h>
#import "CNContactFormatHelper.h"

@implementation CNContactFormatHelper

+ (NSDate *) dateFromDateComponents:(NSDateComponents *) dateComponents
{
    if(dateComponents == nil) {
        return nil;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    
    return [cal dateFromComponents:dateComponents];
}


+ (NSMutableArray<NSString *>*) stringArrayFromCNLabeledValueArray:(NSArray<CNLabeledValue *> *) labeledValueArray
{
    NSMutableArray<NSString *> * stringArray = [[NSMutableArray alloc] init];
    
    for(CNLabeledValue * labeledValue in labeledValueArray) {
        if ([labeledValue.value isKindOfClass:[CNPhoneNumber class]]) {
            CNPhoneNumber * phoneNumber = ((CNPhoneNumber *)labeledValue.value);
            [stringArray addObject:[phoneNumber valueForKey:@"digits"]];
        } else if ([labeledValue.value isKindOfClass:[CNSocialProfile class]]) {
            CNSocialProfile * socialProfile = ((CNSocialProfile *)labeledValue.value);
            [stringArray addObject:[socialProfile valueForKey:@"username"]];
        } else if ([labeledValue.value isKindOfClass:[CNPostalAddress class]]) {
            CNPostalAddress * postalAddress = ((CNPostalAddress *)labeledValue.value);
            [stringArray addObject:[postalAddress valueForKey:@"country"]];
        } else {
            [stringArray addObject: [NSString stringWithFormat:@"%@", labeledValue.value]];
        }
    }
    
    return stringArray;
}

@end
