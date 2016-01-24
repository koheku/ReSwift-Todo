/* Copyright (c) 2014-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "_ASPendingState.h"

#import "_ASCoreAnimationExtras.h"
#import "_ASAsyncTransactionContainer.h"
#import "ASAssert.h"

@implementation _ASPendingState
{
  @package //Expose all ivars for ASDisplayNode to bypass getters for efficiency

  UIViewAutoresizing autoresizingMask;
  unsigned int edgeAntialiasingMask;
  CGRect frame;   // Frame is only to be used for synchronous views wrapped by nodes (see setFrame:)
  CGRect bounds;
  CGColorRef backgroundColor;
  id contents;
  CGFloat alpha;
  CGFloat cornerRadius;
  UIViewContentMode contentMode;
  CGPoint anchorPoint;
  CGPoint position;
  CGFloat zPosition;
  CGFloat contentsScale;
  CATransform3D transform;
  CATransform3D sublayerTransform;
  CGColorRef shadowColor;
  CGFloat shadowOpacity;
  CGSize shadowOffset;
  CGFloat shadowRadius;
  CGFloat borderWidth;
  CGColorRef borderColor;
  BOOL asyncTransactionContainer;
  BOOL isAccessibilityElement;
  NSString *accessibilityLabel;
  NSString *accessibilityHint;
  NSString *accessibilityValue;
  UIAccessibilityTraits accessibilityTraits;
  CGRect accessibilityFrame;
  NSString *accessibilityLanguage;
  BOOL accessibilityElementsHidden;
  BOOL accessibilityViewIsModal;
  BOOL shouldGroupAccessibilityChildren;
  NSString *accessibilityIdentifier;

  struct {
    // Properties
    int needsDisplay:1;
    int needsLayout:1;

    // Flags indicating that a given property should be applied to the view at creation
    int setClipsToBounds:1;
    int setOpaque:1;
    int setNeedsDisplayOnBoundsChange:1;
    int setAutoresizesSubviews:1;
    int setAutoresizingMask:1;
    int setFrame:1;
    int setBounds:1;
    int setBackgroundColor:1;
    int setTintColor:1;
    int setContents:1;
    int setHidden:1;
    int setAlpha:1;
    int setCornerRadius:1;
    int setContentMode:1;
    int setNeedsDisplay:1;
    int setAnchorPoint:1;
    int setPosition:1;
    int setZPosition:1;
    int setContentsScale:1;
    int setTransform:1;
    int setSublayerTransform:1;
    int setUserInteractionEnabled:1;
    int setExclusiveTouch:1;
    int setShadowColor:1;
    int setShadowOpacity:1;
    int setShadowOffset:1;
    int setShadowRadius:1;
    int setBorderWidth:1;
    int setBorderColor:1;
    int setAsyncTransactionContainer:1;
    int setAllowsEdgeAntialiasing:1;
    int setEdgeAntialiasingMask:1;
    int setIsAccessibilityElement:1;
    int setAccessibilityLabel:1;
    int setAccessibilityHint:1;
    int setAccessibilityValue:1;
    int setAccessibilityTraits:1;
    int setAccessibilityFrame:1;
    int setAccessibilityLanguage:1;
    int setAccessibilityElementsHidden:1;
    int setAccessibilityViewIsModal:1;
    int setShouldGroupAccessibilityChildren:1;
    int setAccessibilityIdentifier:1;
  } _flags;
}


@synthesize clipsToBounds=clipsToBounds;
@synthesize opaque=opaque;
@synthesize frame=frame;
@synthesize bounds=bounds;
@synthesize backgroundColor=backgroundColor;
@synthesize contents=contents;
@synthesize hidden=isHidden;
@synthesize needsDisplayOnBoundsChange=needsDisplayOnBoundsChange;
@synthesize allowsEdgeAntialiasing=allowsEdgeAntialiasing;
@synthesize edgeAntialiasingMask=edgeAntialiasingMask;
@synthesize autoresizesSubviews=autoresizesSubviews;
@synthesize autoresizingMask=autoresizingMask;
@synthesize tintColor=tintColor;
@synthesize alpha=alpha;
@synthesize cornerRadius=cornerRadius;
@synthesize contentMode=contentMode;
@synthesize anchorPoint=anchorPoint;
@synthesize position=position;
@synthesize zPosition=zPosition;
@synthesize contentsScale=contentsScale;
@synthesize transform=transform;
@synthesize sublayerTransform=sublayerTransform;
@synthesize userInteractionEnabled=userInteractionEnabled;
@synthesize exclusiveTouch=exclusiveTouch;
@synthesize shadowColor=shadowColor;
@synthesize shadowOpacity=shadowOpacity;
@synthesize shadowOffset=shadowOffset;
@synthesize shadowRadius=shadowRadius;
@synthesize borderWidth=borderWidth;
@synthesize borderColor=borderColor;
@synthesize asyncdisplaykit_asyncTransactionContainer=asyncTransactionContainer;


static CGColorRef blackColorRef = NULL;
static UIColor *defaultTintColor = nil;

- (id)init
{
  if (!(self = [super init]))
    return nil;


  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // Default UIKit color is an RGB color
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    blackColorRef = CGColorCreate(colorSpace, (CGFloat[]){0,0,0,1} );
    CFRetain(blackColorRef);
    CGColorSpaceRelease(colorSpace);
    defaultTintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.0 alpha:1.0];
  });

  // Set defaults, these come from the defaults specified in CALayer and UIView
  clipsToBounds = NO;
  opaque = YES;
  frame = CGRectZero;
  bounds = CGRectZero;
  backgroundColor = nil;
  tintColor = defaultTintColor;
  contents = nil;
  isHidden = NO;
  needsDisplayOnBoundsChange = NO;
  autoresizesSubviews = YES;
  alpha = 1.0f;
  cornerRadius = 0.0f;
  contentMode = UIViewContentModeScaleToFill;
  _flags.needsDisplay = NO;
  anchorPoint = CGPointMake(0.5, 0.5);
  position = CGPointZero;
  zPosition = 0.0;
  contentsScale = 1.0f;
  transform = CATransform3DIdentity;
  sublayerTransform = CATransform3DIdentity;
  userInteractionEnabled = YES;
  shadowColor = blackColorRef;
  shadowOpacity = 0.0;
  shadowOffset = CGSizeMake(0, -3);
  shadowRadius = 3;
  borderWidth = 0;
  borderColor = blackColorRef;
  isAccessibilityElement = NO;
  accessibilityLabel = nil;
  accessibilityHint = nil;
  accessibilityValue = nil;
  accessibilityTraits = UIAccessibilityTraitNone;
  accessibilityFrame = CGRectZero;
  accessibilityLanguage = nil;
  accessibilityElementsHidden = NO;
  accessibilityViewIsModal = NO;
  shouldGroupAccessibilityChildren = NO;
  accessibilityIdentifier = nil;
  edgeAntialiasingMask = (kCALayerLeftEdge | kCALayerRightEdge | kCALayerTopEdge | kCALayerBottomEdge);

  return self;
}

- (CALayer *)layer
{
  ASDisplayNodeAssert(NO, @"One shouldn't call node.layer when the view isn't loaded, but we're returning nil to not crash if someone is still doing this");
  return nil;
}

- (void)setNeedsDisplay
{
  _flags.needsDisplay = YES;
}

- (void)setNeedsLayout
{
  _flags.needsLayout = YES;
}

- (void)setClipsToBounds:(BOOL)flag
{
  clipsToBounds = flag;
  _flags.setClipsToBounds = YES;
}

- (void)setOpaque:(BOOL)flag
{
  opaque = flag;
  _flags.setOpaque = YES;
}

- (void)setNeedsDisplayOnBoundsChange:(BOOL)flag
{
  needsDisplayOnBoundsChange = flag;
  _flags.setNeedsDisplayOnBoundsChange = YES;
}

- (void)setAllowsEdgeAntialiasing:(BOOL)flag
{
  allowsEdgeAntialiasing = flag;
  _flags.setAllowsEdgeAntialiasing = YES;
}

- (void)setEdgeAntialiasingMask:(unsigned int)mask
{
  edgeAntialiasingMask = mask;
  _flags.setEdgeAntialiasingMask = YES;
}

- (void)setAutoresizesSubviews:(BOOL)flag
{
  autoresizesSubviews = flag;
  _flags.setAutoresizesSubviews = YES;
}

- (void)setAutoresizingMask:(UIViewAutoresizing)mask
{
  autoresizingMask = mask;
  _flags.setAutoresizingMask = YES;
}

- (void)setFrame:(CGRect)newFrame
{
  frame = newFrame;
  _flags.setFrame = YES;
}

- (void)setBounds:(CGRect)newBounds
{
  bounds = newBounds;
  _flags.setBounds = YES;
}

- (CGColorRef)backgroundColor
{
  return backgroundColor;
}

- (void)setBackgroundColor:(CGColorRef)color
{
  if (color == backgroundColor) {
    return;
  }

  CGColorRelease(backgroundColor);
  backgroundColor = CGColorRetain(color);
  _flags.setBackgroundColor = YES;
}

- (void)setTintColor:(UIColor *)newTintColor
{
  tintColor = newTintColor;
  _flags.setTintColor = YES;
}

- (void)setContents:(id)newContents
{
  if (contents == newContents) {
    return;
  }

  contents = newContents;
  _flags.setContents = YES;
}

- (void)setHidden:(BOOL)flag
{
  isHidden = flag;
  _flags.setHidden = YES;
}

- (void)setAlpha:(CGFloat)newAlpha
{
  alpha = newAlpha;
  _flags.setAlpha = YES;
}

- (void)setCornerRadius:(CGFloat)newCornerRadius
{
  cornerRadius = newCornerRadius;
  _flags.setCornerRadius = YES;
}

- (void)setContentMode:(UIViewContentMode)newContentMode
{
  contentMode = newContentMode;
  _flags.setContentMode = YES;
}

- (void)setAnchorPoint:(CGPoint)newAnchorPoint
{
  anchorPoint = newAnchorPoint;
  _flags.setAnchorPoint = YES;
}

- (void)setPosition:(CGPoint)newPosition
{
  position = newPosition;
  _flags.setPosition = YES;
}

- (void)setZPosition:(CGFloat)newPosition
{
  zPosition = newPosition;
  _flags.setZPosition = YES;
}

- (void)setContentsScale:(CGFloat)newContentsScale
{
  contentsScale = newContentsScale;
  _flags.setContentsScale = YES;
}

- (void)setTransform:(CATransform3D)newTransform
{
  transform = newTransform;
  _flags.setTransform = YES;
}

- (void)setSublayerTransform:(CATransform3D)newSublayerTransform
{
  sublayerTransform = newSublayerTransform;
  _flags.setSublayerTransform = YES;
}

- (void)setUserInteractionEnabled:(BOOL)flag
{
  userInteractionEnabled = flag;
  _flags.setUserInteractionEnabled = YES;
}

- (void)setExclusiveTouch:(BOOL)flag
{
  exclusiveTouch = flag;
  _flags.setExclusiveTouch = YES;
}

- (void)setShadowColor:(CGColorRef)color
{
  if (shadowColor == color) {
    return;
  }

  if (shadowColor != blackColorRef) {
    CGColorRelease(shadowColor);
  }
  shadowColor = color;
  CGColorRetain(shadowColor);

  _flags.setShadowColor = YES;
}

- (void)setShadowOpacity:(CGFloat)newOpacity
{
  shadowOpacity = newOpacity;
  _flags.setShadowOpacity = YES;
}

- (void)setShadowOffset:(CGSize)newOffset
{
  shadowOffset = newOffset;
  _flags.setShadowOffset = YES;
}

- (void)setShadowRadius:(CGFloat)newRadius
{
  shadowRadius = newRadius;
  _flags.setShadowRadius = YES;
}

- (void)setBorderWidth:(CGFloat)newWidth
{
  borderWidth = newWidth;
  _flags.setBorderWidth = YES;
}

- (void)setBorderColor:(CGColorRef)color
{
  if (borderColor == color) {
    return;
  }

  if (borderColor != blackColorRef) {
    CGColorRelease(borderColor);
  }
  borderColor = color;
  CGColorRetain(borderColor);

  _flags.setBorderColor = YES;
}

- (void)asyncdisplaykit_setAsyncTransactionContainer:(BOOL)flag
{
  asyncTransactionContainer = flag;
  _flags.setAsyncTransactionContainer = YES;
}

- (BOOL)isAccessibilityElement
{
  return isAccessibilityElement;
}

- (void)setIsAccessibilityElement:(BOOL)newIsAccessibilityElement
{
  isAccessibilityElement = newIsAccessibilityElement;
  _flags.setIsAccessibilityElement = YES;
}

- (NSString *)accessibilityLabel
{
  return accessibilityLabel;
}

- (void)setAccessibilityLabel:(NSString *)newAccessibilityLabel
{
  _flags.setAccessibilityLabel = YES;
  if (accessibilityLabel != newAccessibilityLabel) {
    accessibilityLabel = [newAccessibilityLabel copy];
  }
}

- (NSString *)accessibilityHint
{
  return accessibilityHint;
}

- (void)setAccessibilityHint:(NSString *)newAccessibilityHint
{
  _flags.setAccessibilityHint = YES;
  accessibilityHint = [newAccessibilityHint copy];
}

- (NSString *)accessibilityValue
{
  return accessibilityValue;
}

- (void)setAccessibilityValue:(NSString *)newAccessibilityValue
{
  _flags.setAccessibilityValue = YES;
  accessibilityValue = [newAccessibilityValue copy];
}

- (UIAccessibilityTraits)accessibilityTraits
{
  return accessibilityTraits;
}

- (void)setAccessibilityTraits:(UIAccessibilityTraits)newAccessibilityTraits
{
  accessibilityTraits = newAccessibilityTraits;
  _flags.setAccessibilityTraits = YES;
}

- (CGRect)accessibilityFrame
{
  return accessibilityFrame;
}

- (void)setAccessibilityFrame:(CGRect)newAccessibilityFrame
{
  accessibilityFrame = newAccessibilityFrame;
  _flags.setAccessibilityFrame = YES;
}

- (NSString *)accessibilityLanguage
{
  return accessibilityLanguage;
}

- (void)setAccessibilityLanguage:(NSString *)newAccessibilityLanguage
{
  _flags.setAccessibilityLanguage = YES;
  accessibilityLanguage = newAccessibilityLanguage;
}

- (BOOL)accessibilityElementsHidden
{
  return accessibilityElementsHidden;
}

- (void)setAccessibilityElementsHidden:(BOOL)newAccessibilityElementsHidden
{
  accessibilityElementsHidden = newAccessibilityElementsHidden;
  _flags.setAccessibilityElementsHidden = YES;
}

- (BOOL)accessibilityViewIsModal
{
  return accessibilityViewIsModal;
}

- (void)setAccessibilityViewIsModal:(BOOL)newAccessibilityViewIsModal
{
  accessibilityViewIsModal = newAccessibilityViewIsModal;
  _flags.setAccessibilityViewIsModal = YES;
}

- (BOOL)shouldGroupAccessibilityChildren
{
  return shouldGroupAccessibilityChildren;
}

- (void)setShouldGroupAccessibilityChildren:(BOOL)newShouldGroupAccessibilityChildren
{
  shouldGroupAccessibilityChildren = newShouldGroupAccessibilityChildren;
  _flags.setShouldGroupAccessibilityChildren = YES;
}

- (NSString *)accessibilityIdentifier
{
  return accessibilityIdentifier;
}

- (void)setAccessibilityIdentifier:(NSString *)newAccessibilityIdentifier
{
  _flags.setAccessibilityIdentifier = YES;
  if (accessibilityIdentifier != newAccessibilityIdentifier) {
    accessibilityIdentifier = [newAccessibilityIdentifier copy];
  }
}

- (void)applyToLayer:(CALayer *)layer
{
  if (_flags.setAnchorPoint)
    layer.anchorPoint = anchorPoint;

  if (_flags.setPosition)
    layer.position = position;

  if (_flags.setZPosition)
    layer.zPosition = zPosition;

  if (_flags.setBounds)
    layer.bounds = bounds;

  if (_flags.setContentsScale)
    layer.contentsScale = contentsScale;

  if (_flags.setTransform)
    layer.transform = transform;

  if (_flags.setSublayerTransform)
    layer.sublayerTransform = sublayerTransform;

  if (_flags.setContents)
    layer.contents = contents;

  if (_flags.setClipsToBounds)
    layer.masksToBounds = clipsToBounds;

  if (_flags.setBackgroundColor)
    layer.backgroundColor = backgroundColor;

  if (_flags.setOpaque)
    layer.opaque = opaque;

  if (_flags.setHidden)
    layer.hidden = isHidden;

  if (_flags.setAlpha)
    layer.opacity = alpha;

  if (_flags.setCornerRadius)
    layer.cornerRadius = cornerRadius;

  if (_flags.setContentMode)
    layer.contentsGravity = ASDisplayNodeCAContentsGravityFromUIContentMode(contentMode);

  if (_flags.setShadowColor)
    layer.shadowColor = shadowColor;

  if (_flags.setShadowOpacity)
    layer.shadowOpacity = shadowOpacity;

  if (_flags.setShadowOffset)
    layer.shadowOffset = shadowOffset;

  if (_flags.setShadowRadius)
    layer.shadowRadius = shadowRadius;

  if (_flags.setBorderWidth)
    layer.borderWidth = borderWidth;

  if (_flags.setBorderColor)
    layer.borderColor = borderColor;

  if (_flags.setNeedsDisplayOnBoundsChange)
    layer.needsDisplayOnBoundsChange = needsDisplayOnBoundsChange;

  if (_flags.setAllowsEdgeAntialiasing)
    layer.allowsEdgeAntialiasing = allowsEdgeAntialiasing;

  if (_flags.setEdgeAntialiasingMask)
    layer.edgeAntialiasingMask = edgeAntialiasingMask;

  if (_flags.needsDisplay)
    [layer setNeedsDisplay];

  if (_flags.needsLayout)
    [layer setNeedsLayout];

  if (_flags.setAsyncTransactionContainer)
    layer.asyncdisplaykit_asyncTransactionContainer = asyncTransactionContainer;

  if (_flags.setOpaque)
    ASDisplayNodeAssert(layer.opaque == opaque, @"Didn't set opaque as desired");
  
  if (_flags.setFrame)
    ASDisplayNodeAssert(NO, @"Frame property should only be used for synchronously wrapped nodes.  See setFrame: in ASDisplayNode+UIViewBridge");
}

- (void)applyToView:(UIView *)view
{
  /*
   Use our convenience setters blah here instead of layer.blah
   We were accidentally setting some properties on layer here, but view in UIViewBridgeOptimizations.

   That could easily cause bugs where it mattered whether you set something up on a bg thread on in -didLoad
   because a different setter would be called.
   */

  CALayer *layer = view.layer;

  if (_flags.setAnchorPoint)
    layer.anchorPoint = anchorPoint;

  if (_flags.setPosition)
    layer.position = position;

  if (_flags.setZPosition)
    layer.zPosition = zPosition;

  // This should only be used for synchronous views wrapped by nodes.
  if (_flags.setFrame && !(_flags.setBounds && _flags.setPosition)) {
    view.frame = frame;
  }
  
  if (_flags.setBounds)
    view.bounds = bounds;

  if (_flags.setContentsScale)
    layer.contentsScale = contentsScale;

  if (_flags.setTransform)
    layer.transform = transform;

  if (_flags.setSublayerTransform)
    layer.sublayerTransform = sublayerTransform;

  if (_flags.setContents)
    layer.contents = contents;

  if (_flags.setClipsToBounds)
    view.clipsToBounds = clipsToBounds;

  if (_flags.setBackgroundColor)
    layer.backgroundColor = backgroundColor;

  if (_flags.setTintColor)
    view.tintColor = self.tintColor;

  if (_flags.setOpaque)
    view.layer.opaque = opaque;

  if (_flags.setHidden)
    view.hidden = isHidden;

  if (_flags.setAlpha)
    view.alpha = alpha;

  if (_flags.setCornerRadius)
    layer.cornerRadius = cornerRadius;

  if (_flags.setContentMode)
    view.contentMode = contentMode;

  if (_flags.setUserInteractionEnabled)
    view.userInteractionEnabled = userInteractionEnabled;

  if (_flags.setExclusiveTouch)
    view.exclusiveTouch = exclusiveTouch;

  if (_flags.setShadowColor)
    layer.shadowColor = shadowColor;

  if (_flags.setShadowOpacity)
    layer.shadowOpacity = shadowOpacity;

  if (_flags.setShadowOffset)
    layer.shadowOffset = shadowOffset;

  if (_flags.setShadowRadius)
    layer.shadowRadius = shadowRadius;

  if (_flags.setBorderWidth)
    layer.borderWidth = borderWidth;

  if (_flags.setBorderColor)
    layer.borderColor = borderColor;

  if (_flags.setAutoresizingMask)
    view.autoresizingMask = autoresizingMask;

  if (_flags.setAutoresizesSubviews)
    view.autoresizesSubviews = autoresizesSubviews;

  if (_flags.setNeedsDisplayOnBoundsChange)
    layer.needsDisplayOnBoundsChange = needsDisplayOnBoundsChange;

  if (_flags.setAllowsEdgeAntialiasing)
    layer.allowsEdgeAntialiasing = allowsEdgeAntialiasing;

  if (_flags.setEdgeAntialiasingMask)
    layer.edgeAntialiasingMask = edgeAntialiasingMask;

  if (_flags.needsDisplay)
    [view setNeedsDisplay];

  if (_flags.needsLayout)
    [view setNeedsLayout];

  if (_flags.setAsyncTransactionContainer)
    view.asyncdisplaykit_asyncTransactionContainer = asyncTransactionContainer;

  if (_flags.setOpaque)
    ASDisplayNodeAssert(view.layer.opaque == opaque, @"Didn't set opaque as desired");

  if (_flags.setIsAccessibilityElement)
    view.isAccessibilityElement = isAccessibilityElement;

  if (_flags.setAccessibilityLabel)
    view.accessibilityLabel = accessibilityLabel;

  if (_flags.setAccessibilityHint)
    view.accessibilityHint = accessibilityHint;

  if (_flags.setAccessibilityValue)
    view.accessibilityValue = accessibilityValue;

  if (_flags.setAccessibilityTraits)
    view.accessibilityTraits = accessibilityTraits;

  if (_flags.setAccessibilityFrame)
    view.accessibilityFrame = accessibilityFrame;

  if (_flags.setAccessibilityLanguage)
    view.accessibilityLanguage = accessibilityLanguage;

  if (_flags.setAccessibilityElementsHidden)
    view.accessibilityElementsHidden = accessibilityElementsHidden;

  if (_flags.setAccessibilityViewIsModal)
    view.accessibilityViewIsModal = accessibilityViewIsModal;

  if (_flags.setShouldGroupAccessibilityChildren)
    view.shouldGroupAccessibilityChildren = shouldGroupAccessibilityChildren;

  if (_flags.setAccessibilityIdentifier)
    view.accessibilityIdentifier = accessibilityIdentifier;
}

// FIXME: Make this more efficient by tracking which properties are set rather than reading everything.
+ (_ASPendingState *)pendingViewStateFromLayer:(CALayer *)layer
{
  if (!layer) {
    return nil;
  }
  
  _ASPendingState *pendingState = [[_ASPendingState alloc] init];
  
  pendingState.anchorPoint = layer.anchorPoint;
  (pendingState->_flags).setAnchorPoint = YES;
  
  pendingState.position = layer.position;
  (pendingState->_flags).setPosition = YES;
  
  pendingState.zPosition = layer.zPosition;
  (pendingState->_flags).setZPosition = YES;
  
  pendingState.bounds = layer.bounds;
  (pendingState->_flags).setBounds = YES;
  
  pendingState.contentsScale = layer.contentsScale;
  (pendingState->_flags).setContentsScale = YES;
  
  pendingState.transform = layer.transform;
  (pendingState->_flags).setTransform = YES;
  
  pendingState.sublayerTransform = layer.sublayerTransform;
  (pendingState->_flags).setSublayerTransform = YES;
  
  pendingState.contents = layer.contents;
  (pendingState->_flags).setContents = YES;
  
  pendingState.clipsToBounds = layer.masksToBounds;
  (pendingState->_flags).setClipsToBounds = YES;
  
  pendingState.backgroundColor = layer.backgroundColor;
  (pendingState->_flags).setBackgroundColor = YES;
  
  pendingState.opaque = layer.opaque;
  (pendingState->_flags).setOpaque = YES;
  
  pendingState.hidden = layer.hidden;
  (pendingState->_flags).setHidden = YES;
  
  pendingState.alpha = layer.opacity;
  (pendingState->_flags).setAlpha = YES;
  
  pendingState.cornerRadius = layer.cornerRadius;
  (pendingState->_flags).setCornerRadius = YES;
  
  pendingState.contentMode = ASDisplayNodeUIContentModeFromCAContentsGravity(layer.contentsGravity);
  (pendingState->_flags).setContentMode = YES;
  
  pendingState.shadowColor = layer.shadowColor;
  (pendingState->_flags).setShadowColor = YES;
  
  pendingState.shadowOpacity = layer.shadowOpacity;
  (pendingState->_flags).setShadowOpacity = YES;
  
  pendingState.shadowOffset = layer.shadowOffset;
  (pendingState->_flags).setShadowOffset = YES;
  
  pendingState.shadowRadius = layer.shadowRadius;
  (pendingState->_flags).setShadowRadius = YES;
  
  pendingState.borderWidth = layer.borderWidth;
  (pendingState->_flags).setBorderWidth = YES;
  
  pendingState.borderColor = layer.borderColor;
  (pendingState->_flags).setBorderColor = YES;
  
  pendingState.needsDisplayOnBoundsChange = layer.needsDisplayOnBoundsChange;
  (pendingState->_flags).setNeedsDisplayOnBoundsChange = YES;
  
  pendingState.allowsEdgeAntialiasing = layer.allowsEdgeAntialiasing;
  (pendingState->_flags).setAllowsEdgeAntialiasing = YES;
  
  pendingState.edgeAntialiasingMask = layer.edgeAntialiasingMask;
  (pendingState->_flags).setEdgeAntialiasingMask = YES;
  
  return pendingState;
}

// FIXME: Make this more efficient by tracking which properties are set rather than reading everything.
+ (_ASPendingState *)pendingViewStateFromView:(UIView *)view
{
  if (!view) {
    return nil;
  }
  
  _ASPendingState *pendingState = [[_ASPendingState alloc] init];
  
  CALayer *layer = view.layer;
  
  pendingState.anchorPoint = layer.anchorPoint;
  (pendingState->_flags).setAnchorPoint = YES;
  
  pendingState.position = layer.position;
  (pendingState->_flags).setPosition = YES;
  
  pendingState.zPosition = layer.zPosition;
  (pendingState->_flags).setZPosition = YES;
  
  pendingState.bounds = view.bounds;
  (pendingState->_flags).setBounds = YES;
  
  pendingState.contentsScale = layer.contentsScale;
  (pendingState->_flags).setContentsScale = YES;
  
  pendingState.transform = layer.transform;
  (pendingState->_flags).setTransform = YES;
  
  pendingState.sublayerTransform = layer.sublayerTransform;
  (pendingState->_flags).setSublayerTransform = YES;
  
  pendingState.contents = layer.contents;
  (pendingState->_flags).setContents = YES;
  
  pendingState.clipsToBounds = view.clipsToBounds;
  (pendingState->_flags).setClipsToBounds = YES;
  
  pendingState.backgroundColor = layer.backgroundColor;
  (pendingState->_flags).setBackgroundColor = YES;
  
  pendingState.tintColor = view.tintColor;
  (pendingState->_flags).setTintColor = YES;
  
  pendingState.opaque = layer.opaque;
  (pendingState->_flags).setOpaque = YES;
  
  pendingState.hidden = view.hidden;
  (pendingState->_flags).setHidden = YES;
  
  pendingState.alpha = view.alpha;
  (pendingState->_flags).setAlpha = YES;
  
  pendingState.cornerRadius = layer.cornerRadius;
  (pendingState->_flags).setCornerRadius = YES;
  
  pendingState.contentMode = view.contentMode;
  (pendingState->_flags).setContentMode = YES;
  
  pendingState.userInteractionEnabled = view.userInteractionEnabled;
  (pendingState->_flags).setUserInteractionEnabled = YES;
  
  pendingState.exclusiveTouch = view.exclusiveTouch;
  (pendingState->_flags).setExclusiveTouch = YES;
  
  pendingState.shadowColor = layer.shadowColor;
  (pendingState->_flags).setShadowColor = YES;
  
  pendingState.shadowOpacity = layer.shadowOpacity;
  (pendingState->_flags).setShadowOpacity = YES;
  
  pendingState.shadowOffset = layer.shadowOffset;
  (pendingState->_flags).setShadowOffset = YES;
  
  pendingState.shadowRadius = layer.shadowRadius;
  (pendingState->_flags).setShadowRadius = YES;
  
  pendingState.borderWidth = layer.borderWidth;
  (pendingState->_flags).setBorderWidth = YES;
  
  pendingState.borderColor = layer.borderColor;
  (pendingState->_flags).setBorderColor = YES;
  
  pendingState.autoresizingMask = view.autoresizingMask;
  (pendingState->_flags).setAutoresizingMask = YES;
  
  pendingState.autoresizesSubviews = view.autoresizesSubviews;
  (pendingState->_flags).setAutoresizesSubviews = YES;
  
  pendingState.needsDisplayOnBoundsChange = layer.needsDisplayOnBoundsChange;
  (pendingState->_flags).setNeedsDisplayOnBoundsChange = YES;
  
  pendingState.allowsEdgeAntialiasing = layer.allowsEdgeAntialiasing;
  (pendingState->_flags).setAllowsEdgeAntialiasing = YES;
  
  pendingState.edgeAntialiasingMask = layer.edgeAntialiasingMask;
  (pendingState->_flags).setEdgeAntialiasingMask = YES;

  pendingState.isAccessibilityElement = view.isAccessibilityElement;
  (pendingState->_flags).setIsAccessibilityElement = YES;
  
  pendingState.accessibilityLabel = view.accessibilityLabel;
  (pendingState->_flags).setAccessibilityLabel = YES;
  
  pendingState.accessibilityHint = view.accessibilityHint;
  (pendingState->_flags).setAccessibilityHint = YES;
  
  pendingState.accessibilityValue = view.accessibilityValue;
  (pendingState->_flags).setAccessibilityValue = YES;
  
  pendingState.accessibilityTraits = view.accessibilityTraits;
  (pendingState->_flags).setAccessibilityTraits = YES;
  
  pendingState.accessibilityFrame = view.accessibilityFrame;
  (pendingState->_flags).setAccessibilityFrame = YES;
  
  pendingState.accessibilityLanguage = view.accessibilityLanguage;
  (pendingState->_flags).setAccessibilityLanguage = YES;
  
  pendingState.accessibilityElementsHidden = view.accessibilityElementsHidden;
  (pendingState->_flags).setAccessibilityElementsHidden = YES;
  
  pendingState.accessibilityViewIsModal = view.accessibilityViewIsModal;
  (pendingState->_flags).setAccessibilityViewIsModal = YES;
  
  pendingState.shouldGroupAccessibilityChildren = view.shouldGroupAccessibilityChildren;
  (pendingState->_flags).setShouldGroupAccessibilityChildren = YES;
  
  pendingState.accessibilityIdentifier = view.accessibilityIdentifier;
  (pendingState->_flags).setAccessibilityIdentifier = YES;
  
  return pendingState;
}

- (void)dealloc
{
  CGColorRelease(backgroundColor);
  
  if (shadowColor != blackColorRef) {
    CGColorRelease(shadowColor);
  }
  
  if (borderColor != blackColorRef) {
    CGColorRelease(borderColor);
  }
}

@end
