/* Copyright (c) 2014-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ASRangeHandlerPreload.h"
#import "ASDisplayNode.h"
#import "ASDisplayNode+FrameworkPrivate.h"

@implementation ASRangeHandlerPreload

- (void)node:(ASDisplayNode *)node enteredRangeOfType:(ASLayoutRangeType)rangeType
{
  ASDisplayNodeAssert(rangeType == ASLayoutRangeTypeFetchData, @"Preload delegate should not handle other ranges");
  [node enterInterfaceState:ASInterfaceStateFetchData];
}

- (void)node:(ASDisplayNode *)node exitedRangeOfType:(ASLayoutRangeType)rangeType
{
  ASDisplayNodeAssert(rangeType == ASLayoutRangeTypeFetchData, @"Preload delegate should not handle other ranges");
  [node exitInterfaceState:ASInterfaceStateFetchData];
}

@end
