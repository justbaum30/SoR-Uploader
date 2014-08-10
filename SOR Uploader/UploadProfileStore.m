//
//  UploadProfileStore.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/8/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "UploadProfileStore.h"
#import "UploadProfile.h"

NSString * const UploadProfilesKey = @"UploadProfiles";

@interface UploadProfileStore ()
{
    NSMutableArray *allProfiles;
}
@end

@implementation UploadProfileStore

+ (void)initialize
{
    UploadProfile *profile1 = [[UploadProfile alloc] initWithName:@"Sons of Realty"
                                                      ReceiptPath:@"/SoR-Receipt/"
                                                      MileagePath:@"/SoR-Mileage/"];
    
    UploadProfile *profile2 = [[UploadProfile alloc] initWithName:@"Brecken Construction"
                                                      ReceiptPath:@"/Brecken-Receipt/"
                                                      MileagePath:@"/Brecken-Mileage/"];
    
    NSMutableArray *profiles = [[NSMutableArray alloc] initWithObjects:profile1, profile2, nil];
    NSData *encodedProfiles = [NSKeyedArchiver archivedDataWithRootObject:profiles];
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:encodedProfiles forKey:UploadProfilesKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

+ (UploadProfileStore *)sharedStore
{
    static UploadProfileStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}


- (id)init
{
    self = [super init];
    if (self) {
        NSData *encodedProfiles = [[NSUserDefaults standardUserDefaults] objectForKey:UploadProfilesKey];
        allProfiles = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedProfiles];
    }
    return self;
}

- (NSArray *)allProfiles
{
    return allProfiles;
}

- (void)addProfile:(UploadProfile *)profile
{
    [allProfiles addObject:profile];
}

- (void)updateProfile:(UploadProfile *)profile
              atIndex:(NSUInteger)index
{
    [allProfiles setObject:profile atIndexedSubscript:index];
}

- (void)removeProfileAtIndex:(NSUInteger)index
{
    [allProfiles removeObjectAtIndex:index];
}


@end
