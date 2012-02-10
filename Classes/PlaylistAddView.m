    //
//  PlaylistAddView.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 6/1/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "PlaylistAddView.h"
#import "PlaylistNavViewController.h"
#import "MaestroNavViewController.h"

@implementation PlaylistAddView

@synthesize theDocuments;
@synthesize thePlaylist;
@synthesize thePlaylistName;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
	self.thePlaylistName.text = [appModel getCurrentPlaylistName];	
		
	[super setEditing:YES animated:YES];
	[(UITableView *)self.thePlaylist setEditing:YES animated:NO];
	[(UITableView *)self.thePlaylist reloadData];
	[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
}

- (void)viewDidAppear:(BOOL)animated {
	if([self.thePlaylistName.text isEqualToString:@""]) {
	    [self.thePlaylistName becomeFirstResponder];
	}
}

- (void)editPlayList:(id)sender {
	if(self.editing) {
		NSLog(@"turn off editing");	
	} else {
		[super setEditing:YES animated:YES];
	    [(UITableView *)self.thePlaylist setEditing:YES animated:NO];
		[(UITableView *)self.thePlaylist reloadData];
	    [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];

	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *theName = [[appModel getCurrentPlaylistArray] objectAtIndex:0];
		[appModel removeFromPlaylist:theName theIndex:indexPath.row+1];
		[self.theDocuments reloadData];
		[self.thePlaylist reloadData];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Enter the desired text."
							  message: @"Enter text."
							  delegate: self
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		alert.tag=2;
	    //UITextField * nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
		//[nameField setBackgroundColor:[UIColor whiteColor]];
		//[alert addSubview:nameField];
		
		[alert addTextFieldWithValue:@"" label:@"Test Field"];
		textfieldName = [alert textFieldAtIndex:0];
		textfieldName.keyboardType = UIKeyboardTypeAlphabet;
		textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
		textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
		
		CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 100.0);
		[alert setTransform: moveUp];
		[alert show];
		[alert release];
	}
}

// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];

	NSUInteger theRow = indexPath.row;
	NSMutableArray *theArray = [appModel getCurrentPlaylistArray];
	if(theRow < [theArray count]-1) {
		return YES;
	} else {
		return NO;
	}
}

// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
	
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];

	NSMutableArray *aPlaylist = [appModel getCurrentPlaylistArray];
	NSUInteger toRow = toIndexPath.row;
	NSUInteger arraySize = [aPlaylist count];
	
	if(toRow < arraySize-1) {   // don't allow items to be moved to the last line
		NSString *item = [[aPlaylist objectAtIndex:fromIndexPath.row+1] retain];
		[aPlaylist removeObject:item];
		[aPlaylist insertObject:item atIndex:toIndexPath.row+1];
		[item release];
	}
	[tableView reloadData];
}

- (IBAction)playListNameChange:(id)sender {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];

	if([appModel editCurrentPlaylistName:[sender text]]) {
		NSLog(@"added");
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Name Conflict"
							  message: @"This name is already taken for by another playlist.  Please choose another name."
							  delegate: self
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		alert.tag = 1;
		[alert show];
		[alert release];		
	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];

	if(alertView.tag==1) {
		[self.thePlaylistName becomeFirstResponder];
		
		if (buttonIndex != [alertView cancelButtonIndex])
		{
			//NSString *entered = [(AlertPrompt *)alertView enteredText];
			
		}
	} else {
		NSString *someText = textfieldName.text;
		[appModel addStringToCurrentPlaylist:someText];
		[self.thePlaylist reloadData];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];

    if(tableView.tag == 0) {
	    NSArray *theArray = [appModel getTitles];
		return [theArray count];
	} else {
	    return [appModel currentPlaylistLength];   // added 1 for the "insert row" row
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
			
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.indentationLevel = 1;   // not sure what these do
	cell.indentationWidth = 0;   // not sure what these do
	
	cell.detailTextLabel.textColor=[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1];
	
	NSUInteger theRow = indexPath.row;
	
	if (tableView.tag == 0) {
		NSString *theName = [[[appModel getTitles] objectAtIndex:theRow] stringByReplacingOccurrencesOfString:@".pdf" withString:@""];

		if([appModel getIndexForNameInCurrentPlaylist:theName]) {
			cell.textLabel.text=[NSString stringWithFormat:@"%@%@",theName,@" (Already in the list)"];
			cell.textLabel.textColor = [UIColor redColor];
		} else {
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.text=[theName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
		}
	} else {
		NSMutableArray *theArray = [appModel getCurrentPlaylistArray];
		if(theRow < [theArray count]-1) {
	 	    NSString *theName = [theArray objectAtIndex:theRow+1];
			cell.textLabel.text=[theName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
		} else {
			cell.textLabel.text=@"Add Text Line";
		}
}
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];

	if (tableView.tag == 1) {
		NSMutableArray *items = [appModel getCurrentPlaylistArray];
	
        if( indexPath.row == [items count]-1 )
            return UITableViewCellEditingStyleInsert;
	
	    return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleDelete;
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

	if (tableView.tag == 0) {
		[appModel addIndexToPlaylist:indexPath.row];
		[self.thePlaylist reloadData];
		[self.theDocuments reloadData];
	} else {
		NSString *theName = [appModel getFilePath:indexPath.row+1];
		
		if(theName) {
			[(MaestroNavViewController *)self.navigationController showFile:theName];
		}
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
