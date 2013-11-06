//
//  AppDelegate.m
//  ToolbarBadges
//
//  Created by Robert McDowell on 04/11/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import "AppDelegate.h"
#import "NSToolbarBadgedItem.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [NSColor setIgnoresAlpha:NO];
    
    [_badgeValue setStringValue:[_badge badgeValue]];
    
    [_fontNames removeAllItems];
    [_fontNames addItemsWithTitles:[[NSFontManager  sharedFontManager] availableFonts]];
    [_fontNames selectItemWithTitle:[_badge badgeFontName]];
    
    [_textColor setColor:[_badge badgeTextColor]];
    [_textShadowColor setColor:[_badge badgeTextShadowColor]];
    
    [_lineColor setColor:[_badge badgeLineColor]];
    [_fillColor setColor:[_badge badgeFillColor]];
    [_shadowColor setColor:[_badge badgeShadowColor]];
}

-(void)controlTextDidChange:(NSNotification *)obj
{   
    if ([obj.object isKindOfClass:[NSTextField class]])
    {
        [_badge setBadgeValue:[(NSTextField*)obj.object stringValue]];
    }
}

- (IBAction)fontChanged:(id)sender
{
    if ( [sender isKindOfClass:[NSPopUpButton class]] )
    {
        [_badge setBadgeFontName:[(NSPopUpButton*)sender selectedItem].title];
    }
}

- (IBAction)textColorChanged:(id)sender
{
    if ( [sender isKindOfClass:[NSColorWell class]] )
    {
        [_badge setBadgeTextColor:[(NSColorWell*)sender color]];
    }
}

- (IBAction)textShadowColorChanged:(id)sender
{
    if ( [sender isKindOfClass:[NSColorWell class]] )
    {
        [_badge setBadgeTextShadowColor:[(NSColorWell*)sender color]];
    }
}

- (IBAction)lineColorChanged:(id)sender
{
    if ( [sender isKindOfClass:[NSColorWell class]] )
    {
        [_badge setBadgeLineColor:[(NSColorWell*)sender color]];
    }
}

- (IBAction)fillColorChanged:(id)sender
{
    if ( [sender isKindOfClass:[NSColorWell class]] )
    {
        [_badge setBadgeFillColor:[(NSColorWell*)sender color]];
    }
}

- (IBAction)shadowColorChanged:(id)sender
{
    if ( [sender isKindOfClass:[NSColorWell class]] )
    {
        [_badge setBadgeShadowColor:[(NSColorWell*)sender color]];
    }
}

- (IBAction)toolbarAction:(id)sender
{
    // empty action
}

@end
