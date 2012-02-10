    //
//  PlaylistViewController.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/20/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlaylistNavViewController.h"

@implementation PlaylistViewController

@synthesize myTable;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add a Playlist" style:UIBarButtonItemStyleBordered target:self action:@selector(addPlayList:)];
	//self.navigationItem.leftBarButtonItem = nil;
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPlayList:)];
	self.navigationItem.rightBarButtonItem = editButton;
	
	self.editButtonItem.target = self;
	self.editButtonItem.action = @selector(buttonPushed:);
	
	UIView *hackView = [[UIView alloc] initWithFrame:CGRectZero];
	UIBarButtonItem *hackItem = [[UIBarButtonItem alloc] initWithCustomView:hackView];      
	self.navigationItem.leftBarButtonItem = hackItem;
	[hackView release];
	[hackItem release];

	self.title=@"Play Lists";

	//[addButton release];
	[editButton release];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.myTable reloadData];
}

- (void)addPlayList:(id)sender {
	if(self.editing) {
		[super setEditing:NO animated:NO];
	    [(UITableView *)self.myTable setEditing:NO animated:NO];
		[(UITableView *)self.myTable reloadData];
	    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	[(PlaylistNavViewController *)self.navigationController addPlaylist];
}

- (void)editPlayList:(id)sender {
	if(self.editing) {
		[super setEditing:NO animated:NO];
	    [(UITableView *)self.myTable setEditing:NO animated:NO];
		[(UITableView *)self.myTable reloadData];
	    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	} else {
		[super setEditing:YES animated:YES];
	    [(UITableView *)self.myTable setEditing:YES animated:NO];
		[(UITableView *)self.myTable reloadData];
	    [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
		NSMutableArray *thePlaylist = [[appModel getPlaylists] objectAtIndex:[self indexFromIndexPath:indexPath]];
		[appModel removePlaylist:[thePlaylist objectAtIndex:0]];
		[self.myTable reloadData];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self addPlayList:nil];
	}
}

// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row > 0) {
	    return YES;
	} else {
		return NO;	
	}
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {

	if(toIndexPath.row > 0) {
		MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
		
		NSMutableArray *thePlaylists = [appModel getPlaylists];
		
		NSString *item = [[thePlaylists objectAtIndex:fromIndexPath.row] retain];
		[thePlaylists removeObject:item];
		[thePlaylists insertObject:item atIndex:toIndexPath.row];
		[item release];
	}
	[tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView.editing) {
	    return [[(PlaylistNavViewController *)self.navigationController getPlaylists] count]+1;
	} else {
		return [[(PlaylistNavViewController *)self.navigationController getPlaylists] count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
	
	NSMutableArray *thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];
	thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];
	NSUInteger anIndex = [self indexFromIndexPath:indexPath];
	
	if(tableView.editing) {
		if(indexPath.row == 0) {
			cell.textLabel.text=@"Add A New Playlist";
			cell.accessoryType = UITableViewCellSelectionStyleBlue;
		} else {
			if(indexPath.row < [thePlayLists count]+1) {
				cell.textLabel.text = [(NSString *)[[thePlayLists objectAtIndex:anIndex-1] objectAtIndex:0] stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
			}
		}
	} else {
		if(indexPath.row < [thePlayLists count]) {
			cell.textLabel.text = [(NSString *)[[thePlayLists objectAtIndex:anIndex] objectAtIndex:0] stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
			cell.accessoryType = UITableViewCellSelectionStyleBlue;
		}		
	}
	/*
	if(indexPath.row > 0) {
	    if(indexPath.row < [thePlayLists count]) {
	        cell.textLabel.text = (NSString *)[[thePlayLists objectAtIndex:anIndex] objectAtIndex:0];
		}
	} else {
		if(tableView.editing) {
			cell.textLabel.text=@"Add A New Playlist";
			cell.accessoryType = UITableViewCellSelectionStyleBlue;
		} else {
			cell.textLabel.text=@"";
			cell.accessoryType=UITableViewCellSelectionStyleNone;
		}
	}
	 */
	
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.indentationLevel = 1;   // not sure what these do
	cell.indentationWidth = 0;   // not sure what these do
	
	cell.detailTextLabel.textColor=[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1];
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSMutableArray *thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];;
	NSUInteger anIndex;
	thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];
	anIndex = [self indexFromIndexPath:indexPath];
	
	if(tableView.editing) {
		if( indexPath.row == 0 ) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	}
	return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView: (UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];
	thePlayLists = [(PlaylistNavViewController *)self.navigationController getPlaylists];
	
	if(indexPath.row < [thePlayLists count]) {
		return tableView.allowsSelectionDuringEditing = YES;
	} else {
		return tableView.allowsSelectionDuringEditing = YES;
	}
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
	NSMutableArray *thePlaylist = [[NSMutableArray alloc] init];
	
	if(tableView.editing) {
		//[self editPlayList:nil];
 		
		thePlaylist = [[appModel getPlaylists] objectAtIndex:[self indexFromIndexPath:indexPath]-1];
		[appModel setCurrentPlaylist:[thePlaylist objectAtIndex:0]];
		[(PlaylistNavViewController *)self.navigationController showPlaylist:[thePlaylist objectAtIndex:0]];
	} else {
		NSUInteger theRow=indexPath.row;
		thePlaylist = [[appModel getPlaylists] objectAtIndex:theRow];
		[appModel setMyCurrentPlaylist:[thePlaylist objectAtIndex:0]];
		[(PlaylistNavViewController *)self.navigationController usePlaylist:[thePlaylist objectAtIndex:0]];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
	NSMutableArray *thePlaylist = [[appModel getPlaylists] objectAtIndex:[self indexFromIndexPath:indexPath]];
	[appModel setCurrentPlaylist:[thePlaylist objectAtIndex:0]];
	[(PlaylistNavViewController *)self.navigationController showPlaylist:[thePlaylist objectAtIndex:0]];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
	[super setEditing:editing animated:animate];
	if(editing) {
		NSLog(@"editing");
	} else {
		NSLog(@"Not editing");
	}
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
