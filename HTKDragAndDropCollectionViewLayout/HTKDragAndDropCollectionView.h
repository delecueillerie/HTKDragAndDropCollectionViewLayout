//
//  HTKDragAndDropCollectionViewController.h
//  HTKDragAndDropCollectionView
//
//  Created by Henry T Kirk on 11/9/14.
//  Copyright (c) 2014 Henry T. Kirk (http://www.henrytkirk.info)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>
#import "HTKDragAndDropCollectionViewLayout.h"
#import "HTKDraggableCollectionViewCell.h"

/**
 * CollectionViewController that should be sub-classed to implement
 * drag and drop of cells.
 */

@protocol HTKDragAndDropCollectionViewProtocol <UICollectionViewDataSource>

-(void) switchItemAtIndexPath:(NSIndexPath *)pathFrom withItemAtIndexPath:(NSIndexPath *)pathTo;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
@end



@interface HTKDragAndDropCollectionView : UICollectionView <HTKDraggableCollectionViewCellDelegate>

@property(nonatomic, weak) id <HTKDragAndDropCollectionViewProtocol> HTKDragAndDropCollectionViewDelegate;

@property (strong, nonatomic) NSIndexPath *draggedIndexPath;
@property (strong, nonatomic) NSIndexPath *intersectPath;
@end
