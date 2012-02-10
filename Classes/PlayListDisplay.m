//
//  PlaylistViewController.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/20/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "PlayListDisplay.h"
#import "PlaylistNavViewController.h"

@implementation PlayListDisplay

@synthesize myTable;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add a Playlist" style:UIBarButtonItemStyleBordered target:self action:@selector(addPlayList:)];
	self.navigationItem.leftBarButtonItem = addButton;
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPlayList:)];
	self.navigationItem.rightBarButtonItem = editButton;
	
	self.title=@"Play Lists";
	
	[addButton release];
	[editButton release];
}

- (void)addPlayList:(id)sender {
	[(PlaylistNavViewController *)self.navigationController addPlaylist];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.myTable reloadData];
	//NSLog(@"lkjfds");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[(PlaylistNavViewController *)self.navigationController getPlaylists] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
	
	NSMutableArray *thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];;
	NSUInteger anIndex;
	thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];
	anIndex = [self indexFromIndexPath:indexPath];
	cell.textLabel.text = (NSString *)[[thePlayLists objectAtIndex:anIndex] objectAtIndex:0];
	//cell.textLabel.text = @"testing";
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.indentationLevel = 1;   // not sure what these do
	cell.indentationWidth = 0;   // not sure what these do
	
	cell.detailTextLabel.textColor=[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 80.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:14];
	headerLabel.frame = CGRectMake(10.0, -10.0, 300.0, 40.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	headerLabel.text = @"";
	[customView addSubview:headerLabel];
	
	[headerLabel release];
	[customView autorelease];
	
	return customView;
}

- (NSUInteger)indexFromIndexPath:(NSIndexPath*)indexPath
{
    return indexPath.row;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
	NSMutableArray *thePlaylist = [[appModel getPlaylists] objectAtIndex:[self indexFromIndexPath:indexPath]];
	[appModel setCurrentPlaylist:[thePlaylist firstObject]];
	[(PlaylistNavViewController *)self.navigationController showPlaylist:[thePlaylist firstObject]];
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
