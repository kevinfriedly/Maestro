//
//  TouchView.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/18/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "TouchView.h"


@implementation TouchView

@synthesize myFileViewController;

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
	UIView *responderView = [super hitTest:point withEvent:event];//capture the view which actually responds to the touch events
	
	[self.myFileViewController turnPage:(CGPoint)point];

	return self;//pass self so that the touchesBegan,touchesMoved and other events will be routed to this class itself
	
}

//override touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//[responderView touchesBegan:touches withEvent:event];
}

@end
