    //
//  MaestroNavViewController.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "MaestroNavViewController.h"
#import "FileViewController.h"

@implementation MaestroNavViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self showPlaylist:@"Play Lists"];
    }
    return self;
}
*/
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
}
*/

- (void)setCurrentPlaylist:(NSString *)thePlaylist {
	[[(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel] setCurrentPlaylist:thePlaylist];
}

- (void)showFile:(NSString *)thePath {
	FileViewController *fileViewController = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:nil];
	[fileViewController setURL:thePath];
	fileViewController.title=@"Song Viewer";
	
	[(UINavigationController *)self pushViewController:fileViewController animated:YES];
	
}

- (void)showPlaylist:(NSString *)thePath {
	FileViewController *fileViewController = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:nil];
	[fileViewController setURL:thePath];
	fileViewController.title=@"Song Viewer";
	
	[(UINavigationController *)self pushViewController:fileViewController animated:YES];
	
}

- (NSMutableArray *)getPlaylists {
	return [[(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel] getPlaylists];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
