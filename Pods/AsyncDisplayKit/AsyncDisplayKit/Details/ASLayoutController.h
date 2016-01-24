/* Copyright (c) 2014-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import <AsyncDisplayKit/ASBaseDefines.h>
#import <AsyncDisplayKit/ASLayoutRangeType.h>
#import <AsyncDisplayKit/ASScrollDirection.h>

NS_ASSUME_NONNULL_BEGIN

@class ASCellNode;

typedef struct {
  CGFloat leadingBufferScreenfuls;
  CGFloat trailingBufferScreenfuls;
} ASRangeTuningParameters;

@protocol ASLayoutController <NSObject>

/**
 * Tuning parameters for the range.
 *
 * Defaults to a trailing buffer of one screenful and a leading buffer of two screenfuls.
 */
- (void)setTuningParameters:(ASRangeTuningParameters)tuningParameters forRangeType:(ASLayoutRangeType)rangeType;

- (ASRangeTuningParameters)tuningParametersForRangeType:(ASLayoutRangeType)rangeType;

// FIXME: This method can be removed once ASRangeControllerBeta becomes the main version.
- (BOOL)shouldUpdateForVisibleIndexPaths:(NSArray<NSIndexPath *> *)indexPaths rangeType:(ASLayoutRangeType)rangeType;

- (NSSet *)indexPathsForScrolling:(ASScrollDirection)scrollDirection rangeType:(ASLayoutRangeType)rangeType;

@optional

- (void)insertNodesAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withSizes:(NSArray<NSValue *> *)nodeSizes;

- (void)deleteNodesAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)insertSections:(NSArray<NSArray <ASCellNode *>*> *)sections atIndexSet:(NSIndexSet *)indexSet;

- (void)deleteSectionsAtIndexSet:(NSIndexSet *)indexSet;

- (void)setVisibleNodeIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)setViewportSize:(CGSize)viewportSize;
- (CGSize)viewportSize;

@end

NS_ASSUME_NONNULL_END
