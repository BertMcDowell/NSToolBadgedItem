//
//  AppDelegate.h
//  ToolbarBadges
//
//  Created by Robert McDowell on 04/11/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NSToolbarBadgedItem;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextViewDelegate>
{
    IBOutlet NSToolbarBadgedItem * _badge;
    
    IBOutlet NSTextField * _badgeValue;
    IBOutlet NSPopUpButton * _fontNames;
    
    IBOutlet NSColorWell * _textColor;
    IBOutlet NSColorWell * _textShadowColor;

    IBOutlet NSColorWell * _lineColor;
    IBOutlet NSColorWell * _fillColor;
    IBOutlet NSColorWell * _shadowColor;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)fontChanged:(id)sender;
- (IBAction)textColorChanged:(id)sender;
- (IBAction)textShadowColorChanged:(id)sender;

- (IBAction)lineColorChanged:(id)sender;
- (IBAction)fillColorChanged:(id)sender;
- (IBAction)shadowColorChanged:(id)sender;

- (IBAction)toolbarAction:(id)sender;

@end
