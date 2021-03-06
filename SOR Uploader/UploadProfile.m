//
//  UploadProfile.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/4/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "UploadProfile.h"

@implementation UploadProfile

@synthesize name, receiptPath, mileagePath;

- (id)initWithName:(NSString *)aName
       ReceiptPath:(NSString *)aReceiptPath
       MileagePath:(NSString *)aMileagePath
{
    self = [super init];
    if (self) {
        name = aName;
        receiptPath = aReceiptPath;
        mileagePath = aMileagePath;
    }
    return self;
}

#pragma mark - Custom setters

- (void)setReceiptPath:(NSString *)aReceiptPath
{
    if (![aReceiptPath hasPrefix:@"/"]) {
        aReceiptPath = [NSString stringWithFormat:@"/%@", aReceiptPath];
    }
    receiptPath = aReceiptPath;
}

- (void)setMileagePath:(NSString *)aMileagePath
{
    if (![aMileagePath hasPrefix:@"/"]) {
        aMileagePath = [NSString stringWithFormat:@"/%@", aMileagePath];
    }
    mileagePath = aMileagePath;
}

#pragma mark - Encode/Decode

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        name = [decoder decodeObjectForKey:@"name"];
        receiptPath = [decoder decodeObjectForKey:@"receiptPath"];
        mileagePath = [decoder decodeObjectForKey:@"mileagePath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:receiptPath forKey:@"receiptPath"];
    [encoder encodeObject:mileagePath forKey:@"mileagePath"];
}

@end
