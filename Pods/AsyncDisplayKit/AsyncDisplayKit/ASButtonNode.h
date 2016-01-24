/* Copyright (c) 2014-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AsyncDisplayKit/ASTextNode.h>
#import <AsyncDisplayKit/ASImageNode.h>

@interface ASButtonNode : ASControlNode

@property (nonatomic, readonly) ASTextNode *titleNode;
@property (nonatomic, readonly) ASImageNode *imageNode;

/**
 Spacing between image and title. Defaults to 8.0.
 */
@property (nonatomic, assign) CGFloat contentSpacing;

/**
 Whether button should be laid out vertically (image on top of text) or horizontally (image to the left of text).
 ASButton node does not yet support RTL but it should be fairly easy to implement.
 Defaults to YES.
 */
@property (nonatomic, assign) BOOL laysOutHorizontally;

/** Horizontally align content (text or image).
 Defaults to ASAlignmentMiddle.
 */
@property (nonatomic, assign) ASHorizontalAlignment contentHorizontalAlignment;

/** Vertically align content (text or image).
 Defaults to ASAlignmentCenter.
 */
@property (nonatomic, assign) ASVerticalAlignment contentVerticalAlignment;


- (NSAttributedString *)attributedTitleForState:(ASControlState)state;
- (void)setAttributedTitle:(NSAttributedString *)title forState:(ASControlState)state;

- (UIImage *)imageForState:(ASControlState)state;
- (void)setImage:(UIImage *)image forState:(ASControlState)state;

@end
