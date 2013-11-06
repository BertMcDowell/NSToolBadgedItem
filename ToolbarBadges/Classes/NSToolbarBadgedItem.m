//
//  NSToolbarBadgedItem.m
//  ToolbarBadges
//
//  Created by Robert McDowell on 04/11/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import "NSToolbarBadgedItem.h"

@implementation NSToolbarBadgedItem
{
    NSImage * _primary;
    NSImage * _cache;
}

- (id) initWithItemIdentifier:(NSString *)itemIdentifier
{
    if ( self = [super initWithItemIdentifier:itemIdentifier] )
    {
        _badgeLineColor = [NSColor whiteColor];
        _badgeFillColor = [NSColor redColor];
        _badgeShadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.5f];
        
        _badgeTextColor = [NSColor whiteColor];
        _badgeTextShadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.25f];
        
        _badgeFontName = @"Helvetica-Bold";
    }
    return self;
}

- (void) awakeFromNib
{
    if ( [self respondsToSelector:@selector(awakeFromNib)] )
    {
        [super awakeFromNib];
    }
    
    [self refreshBadge];
}

- (void) setImage:(NSImage *)image
{
    _primary = image;
    if ( [_badgeValue length] > 0 )
    {
        _cache = nil;
        [super setImage:[self badgeImage:_badgeValue]];
    }
    else
    {
        [super setImage:image];
    }
}

- (void)setBadge:(NSString *)badgeValue
{
    if ( ![_badgeValue isEqual:badgeValue] )
    {
        if ( [badgeValue length] > 0 )
        {
            [super setImage:[self badgeImage:badgeValue]];
        }
        else
        {
            [super setImage:_primary];
        }
        _badgeValue = [badgeValue copy];
    }
}

- (void)setBadgeFontName:(NSString *)badgeFontName
{
    _badgeFontName = [badgeFontName copy];
    
    [self refreshBadge];
}

- (void)setBadgeTextColor:(NSColor *)badgeTextColor
{
    _badgeTextColor = [badgeTextColor copy];
    
    [self refreshBadge];
}

- (void)setBadgeTextShadowColor:(NSColor *)badgeTextShadowColor
{
    _badgeTextShadowColor = [badgeTextShadowColor copy];
    
    [self refreshBadge];
}

- (void)setBadgeFillColor:(NSColor *)badgeFillColor
{
    _badgeFillColor = [badgeFillColor copy];
    
    [self refreshBadge];
}

- (void)setBadgeLineColor:(NSColor *)badgeLineColor
{
    _badgeLineColor = [badgeLineColor copy];
    
    [self refreshBadge];
}

- (void)setBadgeShadowColor:(NSColor *)badgeShadowColor
{
    _badgeShadowColor = [badgeShadowColor copy];
    
    [self refreshBadge];
}

#pragma mark -- Private Methods

- (void)refreshBadge
{
    if ( [_badgeValue length] > 0 )
    {
        _cache = [self renderImage:_primary withBadge:_badgeValue];
        [super setImage:_cache];
    }
}

- (NSImage *)badgeImage:(NSString*)badgeValue
{
    if ( ![_badgeValue isEqual:badgeValue] || _cache == nil )
    {
        _cache = [self renderImage:_primary withBadge:badgeValue];
    }
    return _cache;
}

- (NSImage *)renderImage:(NSImage *)image withBadge:(NSString*)badge
{
    CGFloat locations[3] = { 1.0, 0.5f, 0.0f };
    NSColor * colorblend = [_badgeFillColor blendedColorWithFraction:0.75f ofColor:_badgeLineColor];
    NSArray * colors = @[ (id)[colorblend CGColor], (id)[_badgeFillColor CGColor], (id)[_badgeFillColor CGColor]];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors (colorSpace, (CFArrayRef)colors, locations);
    
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setMinimumLineHeight:0.0f];
    
    NSImage * newImage = [[NSImage alloc] initWithSize:[image size]];
    for ( NSImageRep * rep in [image representations] )
    {
        NSSize size = [rep size];
        NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: NULL
                                                                           pixelsWide: size.width
                                                                           pixelsHigh: size.height
                                                                        bitsPerSample: 8
                                                                      samplesPerPixel: 4
                                                                             hasAlpha: YES
                                                                             isPlanar: NO
                                                                       colorSpaceName: NSDeviceRGBColorSpace
                                                                          bytesPerRow: size.width * 4
                                                                         bitsPerPixel: 32];
        
        NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: newRep];
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext: ctx];
        
        CGContextRef  context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
        CGContextSaveGState(context);
        CGContextSetAllowsFontSmoothing(context, TRUE);
        CGContextSetAllowsAntialiasing(context, TRUE);
        CGContextSetAllowsFontSubpixelQuantization(context, TRUE);
        CGContextSetAllowsFontSubpixelPositioning(context, TRUE);
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        
        NSRect imageRect = NSMakeRect(0, 0, size.width, size.height);
        CGImageRef ref = [image CGImageForProposedRect:&imageRect context:[NSGraphicsContext currentContext] hints:nil];
        CGContextDrawImage(context, imageRect, ref);
        
        float iconsize = size.width * 0.5f;
        float lineWidth = MAX(1, iconsize * 0.11f);
        float pointSize = iconsize - (lineWidth * 2.0f);
        float radius = iconsize * 0.5f;
        CGSize shadowOffset = (_badgeShadowColor.alphaComponent > FLT_EPSILON) ? CGSizeMake(lineWidth*0.25f, -lineWidth) : CGSizeZero;
        NSPoint indent = NSMakePoint((size.width) - (iconsize + lineWidth + shadowOffset.width), lineWidth - shadowOffset.height);
        NSRect rect = NSMakeRect(indent.x, indent.y, iconsize, iconsize);
        
        // work out the area
        NSFont * font = [NSFont fontWithName:_badgeFontName size:pointSize];
        
        // update the shadow offset
        NSDictionary *attr =nil;
        if (_badgeTextShadowColor.alphaComponent > FLT_EPSILON)
        {
            float fontShadowPointOffset = MAX(pointSize*0.035f, 0.5f);
            NSShadow *shadow = [[NSShadow alloc] init];
            shadow.shadowColor = _badgeTextShadowColor;
            shadow.shadowBlurRadius = 0.5f;
            shadow.shadowOffset = CGSizeMake(fontShadowPointOffset, -fontShadowPointOffset);
            
            attr = @{NSParagraphStyleAttributeName : paragraphStyle,
                     NSFontAttributeName : font,
                     NSShadowAttributeName : shadow,
                     NSForegroundColorAttributeName : _badgeTextColor };
        }
        else
        {
            attr = @{NSParagraphStyleAttributeName : paragraphStyle,
                     NSFontAttributeName : font,
                     NSForegroundColorAttributeName : _badgeTextColor };
        }
    
        NSRect textSize = [badge boundingRectWithSize:NSZeroSize options:NSStringDrawingOneShot attributes:attr];
        if ( textSize.size.width+(lineWidth*4) >= rect.size.width )
        {
            float maxWidth = size.width-(lineWidth*2);
            float width = MIN(textSize.size.width+(lineWidth*4), maxWidth);
            rect.origin.x -= (width - rect.size.width);
            rect.size.width = width;
            
            float newRadius = radius - (radius * ((width - rect.size.width) / (maxWidth-rect.size.width)));
            radius = MAX(iconsize * 0.4f, newRadius);
        }
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        // Draw the ellipse
        CGFloat minx = CGRectGetMinX(rect);
        CGFloat midx = CGRectGetMidX(rect);
        CGFloat maxx = CGRectGetMaxX(rect);
        CGFloat miny = CGRectGetMinY(rect);
        CGFloat midy = CGRectGetMidY(rect);
        CGFloat maxy = CGRectGetMaxY(rect);
        
        // Draw the fill with shadow
        if (_badgeShadowColor.alphaComponent > FLT_EPSILON)
        {
            CGContextSaveGState(context);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, minx, midy);
            CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
            CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
            CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
            CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
            CGContextClosePath(context);
            CGContextSetShadowWithColor(context, shadowOffset, 0.5f, [_badgeShadowColor CGColor]);
            CGContextSetFillColorWithColor(context, [_badgeShadowColor CGColor]);
            CGContextDrawPath(context, kCGPathFill);
            CGContextRestoreGState(context);
        }
        
        // Draw the gradiant
        CGContextSaveGState(context);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, minx, midy);
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
        
        // Draw the text
        NSRect textBounds = [badge boundingRectWithSize:NSZeroSize
                                                options:NSStringDrawingUsesDeviceMetrics
                                             attributes:attr];
//        rect.origin.x = CGRectGetMidX(rect) - (textBounds.size.width * 0.5f);
        rect.origin.x = CGRectGetMidX(rect) - (textSize.size.width * 0.5f);
        rect.origin.x -= (textBounds.size.width - textSize.size.width) * 0.5f;
        rect.origin.y = CGRectGetMidY(rect);
        rect.origin.y -= textBounds.origin.y;
        rect.origin.y -= ((textBounds.size.height - textSize.origin.y) * 0.5f);
        
        rect.size.height = textSize.size.height;
        rect.size.width = textSize.size.width;
        [badge drawInRect:rect withAttributes:attr];
//        [badge drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine attributes:attr];
        CGContextRestoreGState(context);
        
        // Draw the stroke
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, minx+0.5f, midy+0.5f);
        CGContextAddArcToPoint(context, minx+0.5f, miny+0.5f, midx+0.5f, miny+0.5f, radius);
        CGContextAddArcToPoint(context, maxx+0.5f, miny+0.5f, maxx+0.5f, midy+0.5f, radius);
        CGContextAddArcToPoint(context, maxx+0.5f, maxy+0.5f, midx+0.5f, maxy+0.5f, radius);
        CGContextAddArcToPoint(context, minx+0.5f, maxy+0.5f, minx+0.5f, midy+0.5f, radius);
        CGContextClosePath(context);
        
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, [_badgeLineColor CGColor]);
        CGContextDrawPath(context, kCGPathStroke);
        
        // Debug Draw center line
        //        CGContextBeginPath(context);
        //        CGContextMoveToPoint(context, minx, midy);
        //        CGContextAddLineToPoint(context, maxx, midy);
        //        CGContextClosePath(context);
        //        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextFlush(context);
        CGContextRestoreGState(context);
        
        [newImage addRepresentation:newRep];
    }
    
    CFRelease(colorSpace);
    CFRelease(gradient);
    
    return newImage;
}

@end
