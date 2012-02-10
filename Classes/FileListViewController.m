    //
//  FileListViewController.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "FileListViewController.h"
#import "MaestroNavViewController.h"
#import "AnAlert.h"

@implementation FileListViewController

@synthesize docTable;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil editing:(BOOL)areWeEditing {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		if(areWeEditing) {
			[super setEditing:YES animated:YES];
			[(UITableView *)self.docTable setEditing:YES animated:NO];
			[(UITableView *)self.docTable reloadData];
			[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
			[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
		} else {
			[super setEditing:NO animated:YES];
			[(UITableView *)self.docTable setEditing:NO animated:NO];
			[(UITableView *)self.docTable reloadData];
			[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
			[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];			
		}
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editDocList:)];
	self.navigationItem.rightBarButtonItem = editButton;
	self.editButtonItem.target = self;

	self.title=@"Documents";

	[super setEditing:NO animated:YES];
	[(UITableView *)self.docTable setEditing:NO animated:NO];
	[(UITableView *)self.docTable reloadData];
	[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
	[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];			
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)editDocList:(id)sender {
	if(self.editing) {
		[super setEditing:NO animated:NO];
	    [(UITableView *)self.docTable setEditing:NO animated:NO];
		[(UITableView *)self.docTable reloadData];
	    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	} else {
		[super setEditing:YES animated:YES];
	    [(UITableView *)self.docTable setEditing:YES animated:NO];
		[(UITableView *)self.docTable reloadData];
	    [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	NSString *theCurrentPlaylist = [[appModel getCurrentPlaylistArray] objectAtIndex:0];

	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if(theCurrentPlaylist) {
			//[appModel removeFromPlaylist:[theCurrentPlaylist theIndex:indexPath.row]];
			//[appModel removeFromPlaylist:[theCurrentPlaylist objectAtIndex:indexPath.row]];
			[appModel removeFromPlaylist:theCurrentPlaylist theIndex:indexPath.row];
			[self.docTable reloadData];			
		} else {
			//NSString *theName = [[appModel getPDFs] objectAtIndex:indexPath.row];
			[appModel removeFromPlaylist:nil theIndex:indexPath.row-1];
			[self.docTable reloadData];
		}
		
		
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		//UIAlertView *alert = [[UIAlertView alloc]
		//					  initWithTitle: @"Enter the desired text."
		//					  message: @"Enter text."
		//					  delegate: self
		//					  cancelButtonTitle:@"OK"
		//
		AnAlert *alert = [AnAlert alloc];
		alert = [alert initWithTitle:@"Test Field" message:@"Please enter some text in" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay"];
		//alert.tag=1;
		[alert show];
		[alert release];
	
	    //[otherButtonTitles:nil];
		
		//[alert addTextFieldWithValue:@"" label:@"Test Field"];
		//textfieldName = [alert textFieldAtIndex:0];
		//textfieldName.keyboardType = UIKeyboardTypeAlphabet;
		//textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
		//textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
		
		//CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 100.0);
		//[alert setTransform: moveUp];
		//[alert show];
		//[alert release];
	} else {
		NSLog(@"hhmmmm");
	}

}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
	NSString *someText = [alertView enteredText];
	[appModel addStringToMainDocList:someText];
	[appModel sortTitles];
	[self.docTable reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	NSMutableArray *theCurrentPlaylist = [appModel getCurrentPlaylistArray];
	
	if(tableView.editing) {
		if(theCurrentPlaylist) {
			return [theCurrentPlaylist count];
		} else {
			return [[appModel getTitles] count]+1;
		}
	} else {
		if(theCurrentPlaylist) {
			return [theCurrentPlaylist count]-1;
		} else {
			return [[appModel getTitles] count];
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	NSMutableArray *theCurrentPlaylist = [appModel getCurrentPlaylistArray];
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyle)UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
	
	if(tableView.editing) {
		if(theCurrentPlaylist) {
			NSMutableArray *theCurrentPlaylist = [appModel getCurrentPlaylistArray];
			cell.textLabel.text = [[theCurrentPlaylist objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
		} else {
			if(indexPath.row > 0) {
				NSArray *theName = [[appModel getTitles] objectAtIndex:[self indexFromIndexPath:indexPath]-1];
				cell.textLabel.text=[theName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
			} else {
				cell.textLabel.text=@"Add Text Line";
			}			
		}

	} else {
		NSMutableArray *theCurrentPlaylist = [appModel getCurrentPlaylistArray];
		if(theCurrentPlaylist) {
			cell.textLabel.text = [[theCurrentPlaylist objectAtIndex:indexPath.row+1] stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
		} else {
			NSArray *theName = [[appModel getTitles] objectAtIndex:[self indexFromIndexPath:indexPath]];
			cell.textLabel.text=[theName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
		}
	}
	
	//cell.imageView.image=[[UIImage imageNamed:@"Note2.jpg"] imageScaledToSize:CGSizeMake(38, 38)];
	//cell.imageView.layer.masksToBounds = YES;
	//cell.imageView.layer.cornerRadius = 5.0;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.indentationLevel = 1;   // not sure what these do
	cell.indentationWidth = 0;   // not sure what these do
	
	cell.detailTextLabel.textColor=[UIColor colorWithRed:0.7 green:0 blue:0 alpha:1];
	
	return cell;
}

// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row > 0) {
	    return YES;
	} else {
		return NO;	
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {	
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	NSMutableArray *theCurrentPlaylist = [appModel getCurrentPlaylistArray];
	
	if(theCurrentPlaylist) {

		if( indexPath.row == 0 ) {
		//if( indexPath.row == [theCurrentPlaylist count]-1 ) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	} else {

		//if( indexPath.row == [[appModel getPDFs] count] ) {
		if( indexPath.row == 0 ) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
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
    NSUInteger index=0;
    for( int i=0; i<indexPath.section; i++ )
        index += [self.docTable numberOfRowsInSection:i];
	
    index += indexPath.row;
	
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	NSMutableArray *theCurrentPlaylist = [appModel getCurrentPlaylistArray];

	int theIndex = indexPath.row;
	if(theCurrentPlaylist) {
		NSString *thePath = [appModel getFilePath:theIndex+1];
		[(MaestroNavViewController *)self.navigationController showFile:thePath];
	} else {	
		//[(MaestroNavViewController *)self.navigationController showFile:[[appModel getPDFs] objectAtIndex:theIndex]];
		[(MaestroNavViewController *)self.navigationController showFile:[appModel getFullPath:[[appModel getTitles] objectAtIndex:theIndex]]];
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
