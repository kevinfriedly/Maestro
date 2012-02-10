//
//  FileViewController.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/17/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController {
	UIWebView *myWebView;
	NSInteger scrollPosition;
    NSString *myURL;
}

- (void)setURL:(NSString *)thePath;
- (void)turnPage:(CGPoint)thePoint;
- (void)scroll:(int)amountToScroll;

@property (nonatomic,retain) IBOutlet UIWebView *myWebView;
@property (nonatomic, readwrite, assign) NSInteger scrollPosition;
@property (nonatomic, retain) NSString *myURL;

@end
