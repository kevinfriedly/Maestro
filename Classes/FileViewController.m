    //
//  FileViewController.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/17/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "FileViewController.h"
#import "TouchView.h"
#import "MaestroModel.h"
#import "MaestroPlusAppDelegate.h"

@implementation FileViewController


@synthesize myWebView;
@synthesize scrollPosition;
@synthesize myURL;

#define BASEURL [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
static NSString   *BKScrollPosition  = @"BKScrollPosition";
static int		PageSize= 267;
static int		PageWidth=384;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
		
		CGRect frame = self.myWebView.frame;
		// you may need to modify the 5 and 10 below to match the size of the PDF border
		frame.origin.x = frame.origin.x - 5;
		frame.origin.y = frame.origin.y - 5;
		frame.size.width = frame.size.width + 10;
		frame.size.height = frame.size.height + 10;
		self.myWebView.frame = frame;
    }
    return self;
}


- (void)viewDidLoad {
	MaestroModel *appModel = [(MaestroPlusAppDelegate *)[UIApplication sharedApplication].delegate getModel];
	
    ((TouchView *)self.myWebView).myFileViewController = self;
	
	NSArray *theArray = [(NSString *)self.myURL componentsSeparatedByString:@"/"];
	
	// Set scroll position
	[
	 [NSUserDefaults standardUserDefaults] registerDefaults:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithInt:0], BKScrollPosition,
	  nil]
	 ];
	//self.scrollPosition = [[NSUserDefaults standardUserDefaults] integerForKey:BKScrollPosition];
	self.scrollPosition = 0;
	
	NSURL *url = [NSURL fileURLWithPath:self.myURL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	[self.myWebView loadRequest:urlRequest];
	
	self.title = [[theArray lastObject] stringByDeletingPathExtension];
	
	if([appModel getIndexForNameInPDFList:[[theArray lastObject] stringByDeletingPathExtension]]) {
		NSLog(@"what");
	} else {
		[self.myWebView loadHTMLString:[NSString stringWithFormat:@"%@%@%@", @"<html><center><div style='font-size:52pt;word-wrap: break-word'><br><br><br><br><b>",self.title,@"</b></div></center></html>"] baseURL:[NSURL URLWithString:@"http://www.audiodiner.com/"]];
	}
}

-(void)updateView {
    [self.myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0, %d);", self.scrollPosition]];
}

- (void)turnPage:(CGPoint)thePoint { 
	//if (thePoint.x > PageWidth/2) {
	int scrollPosition = [[self.myWebView stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
	
	if (thePoint.x > 200) {
		self.scrollPosition += PageSize;
	} else {
		self.scrollPosition -= PageSize;
	}
    [self scroll:self.scrollPosition];
	
	int scrollPosition2 = [[self.myWebView stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
	if (abs(scrollPosition2 - scrollPosition) < 260) {
		self.scrollPosition -= PageSize;
		[self scroll:self.scrollPosition];
	}
	
	if(self.scrollPosition < 0) {
		self.scrollPosition=0;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
	NSSet *allTouches = [event allTouches];
	switch ([allTouches count]) {
		case 1: 
		{
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			CGPoint thePoint = [touch locationInView:self.view];
			if (thePoint.y < 200) {
				//[self pushViewController:self.myFileListViewController animated:YES];
				NSLog(@"testing");
			} else {
				if (thePoint.x > PageWidth/2) {
					self.scrollPosition += PageSize;
					[self scroll:self.scrollPosition];
				} else {
					self.scrollPosition -= PageSize;
					if(self.scrollPosition < 0) {
						self.scrollPosition=0;
					}
					[self scroll:self.scrollPosition];
				}
			}
			
			break;
		}
		default:
			break;
	}
	
}


- (void)scroll:(int)amountToScroll {
	NSString* s=[[NSString alloc] initWithFormat:@"window.scrollTo(0, %i)",amountToScroll];
	[self.myWebView stringByEvaluatingJavaScriptFromString:s];
	
}

- (void)setURL:(NSString *)thePath {
    self.myURL = thePath;
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
