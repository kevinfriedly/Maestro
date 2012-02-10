//
//  MaestroPlusAppDelegate.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "MaestroPlusAppDelegate.h"
#import "MaestroModel.h"
#import "MaestroNavViewController.h"
#import "FileListViewController.h"
#import "PlaylistNavViewController.h"
#import "PlaylistViewController.h"
#import "PlaylistAddView.h"
#import "PlaylistDisplayView.h"

@implementation MaestroPlusAppDelegate

@synthesize window;
@synthesize appModel;
@synthesize previousPlaylist;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
	self.appModel = [[MaestroModel alloc] init];
	
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
	
	UINavigationController *maestroNavViewController = [[MaestroNavViewController alloc] initWithNibName:@"MaestroNavViewController" bundle:nil];
	FileListViewController *fileListViewController = [[FileListViewController alloc] initWithNibName:@"FileListViewController" bundle:nil];
	[(UINavigationController *)maestroNavViewController pushViewController:fileListViewController animated:NO];
	
	UINavigationController *playListNavViewController = [[PlaylistNavViewController alloc] initWithNibName:@"PlaylistNavViewController" bundle:nil];
	PlaylistViewController *playListViewController = [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
	[(UINavigationController *)playListNavViewController pushViewController:playListViewController animated:NO];

	NSArray *viewControllers = [NSArray arrayWithObjects:maestroNavViewController, playListNavViewController, nil];
	//NSArray *viewControllers = [NSArray arrayWithObjects:playListNavViewController, maestroNavViewController, nil];
	
	[tabBarController setViewControllers:viewControllers];
	
	[window setRootViewController:tabBarController];

    [self.window makeKeyAndVisible];
	
	[self.appModel initModel];
		    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	if([viewController.title isEqualToString:@"Documents"]) {
		self.previousPlaylist = [self.appModel getCurrentPlaylistName];
	    [self.appModel setCurrentPlaylist:@""];
	} else {
		[self.appModel setCurrentPlaylist:self.previousPlaylist];
	}
}


- (MaestroModel *)getModel {
	return self.appModel;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
