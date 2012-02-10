//
//  PlaylistNavViewController.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/20/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "PlaylistNavViewController.h"
#import "PlaylistViewController.h"
#import "PlayListIndividualView.h"
#import "PlaylistAddView.h"
#import "MaestroNavViewController.h"
#import "PlaylistDisplayNavController.h"

@implementation PlaylistDisplayNavController


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self showPlaylist:@"Edit Play Lists"];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad]; 
}

- (void)showPlaylist:(NSString *)thePath {
	PlaylistAddView *playListIndividualView = [[PlaylistAddView alloc] initWithNibName:@"PlaylistAddView" bundle:nil];
	playListIndividualView.title=@"Edit Playlist";
	
	[(UINavigationController *)self pushViewController:playListIndividualView animated:YES];
	[playListIndividualView release];
}

- (void)addPlaylist {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
	NSMutableArray *aPlaylist = [appModel newPlaylist];
	[appModel addToPlaylists:aPlaylist];
	[appModel setCurrentPlaylist:[aPlaylist objectAtIndex:0]];
	
	PlaylistAddView *playListAddView = [[PlaylistAddView alloc] initWithNibName:@"PlaylistAddView" bundle:nil];
	playListAddView.title=@"Add A Playlist";
	[(UINavigationController *)self pushViewController:playListAddView animated:NO];
}

- (NSMutableArray *)getPlaylists {
	return [[(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel] getPlaylists];
}

- (NSArray *)getPDFs {
	return [[(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel] myPDFPaths];
}	

- (NSMutableArray *)newPlaylist {
	return [[(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel] newPlaylist];
}	

- (void)setCurrentPlaylist:(NSString *)thePlaylist {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
	[appModel setCurrentPlaylist:thePlaylist];
	return [appModel setCurrentPlaylist:thePlaylist];
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
