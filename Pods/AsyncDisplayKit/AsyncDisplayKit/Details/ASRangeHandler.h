/* Copyright (c) 2014-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import <AsyncDisplayKit/ASLayoutRangeType.h>

NS_ASSUME_NONNULL_BEGIN

@class ASDisplayNode;

@protocol ASRangeHandler <NSObject>

@required

- (void)node:(ASDisplayNode *)node enteredRangeOfType:(ASLayoutRangeType)rangeType;
- (void)node:(ASDisplayNode *)node exitedRangeOfType:(ASLayoutRangeType)rangeType;

@end

NS_ASSUME_NONNULL_END