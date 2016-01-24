//
//  ASCollectionInternal.h
//  AsyncDisplayKit
//
//  Created by Scott Goodson on 1/1/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "ASCollectionView.h"
#import "ASCollectionNode.h"
#import "ASRangeController.h"

@interface ASCollectionView ()
- (instancetype)_initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout ownedByNode:(BOOL)ownedByNode;

@property (nonatomic, weak, readwrite) ASCollectionNode *collectionNode;
@property (nonatomic, strong, readonly) ASRangeController *rangeController;
@end
