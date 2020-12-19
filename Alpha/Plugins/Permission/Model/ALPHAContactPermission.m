//
//  ALPHAContactPermission.m
//  Alpha
//
//  Created by Dal Rupnik on 03/10/15.
//  Copyright © 2015 Unified Sense. All rights reserved.
//

@import Contacts;
@import AddressBook;

#import "ALPHAContactPermission.h"

@implementation ALPHAContactPermission

#pragma mark - Initialization

- (instancetype)init
{
    return [self initWithIdentifier:@"com.unifiedsense.alpha.data.permission.contact"];
}

#pragma mark - Public Methods

- (NSString *)name
{
    return @"Contacts";
}

- (ALPHAApplicationAuthorizationStatus)status
{
    return (ALPHAApplicationAuthorizationStatus)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized;
}

- (void)requestPermission:(ALPHAPermissionRequestCompletion)completion
{
    [self requestContactsPermissionWithCompletion:^(BOOL granted, NSError *error)
    {
        if (completion)
        {
            completion (self, (granted) ? ALPHAApplicationAuthorizationStatusAuthorized : ALPHAApplicationAuthorizationStatusDenied, error);
        }
    }];
}

#pragma mark - Private Methods

- (void)requestContactsPermissionWithCompletion:(void (^)(BOOL granted, NSError *error))completion
{
    CNContactStore *store = [[CNContactStore alloc] init];
    
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
    {
        if (completion)
        {
            completion(granted, error);
        }
    }];
}

@end
