//
//  HTAppDelegate.h
//  HeyThere
//
//  Created by Adeel Ateeque on 1/13/14.
//  Copyright (c) 2014 HeyThere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
