//
//  HTKDragAndDropCollectionViewLayout.h
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

/**
 * CollectionViewLayout that supports drag and drop of UICollectionViewCells.
 * Currently supports multiple sections but no section header/footers. (In progress)
 * It does not create a "ghost" or "dummy" cell to move around while dragging.
 */
@interface HTKDragAndDropCollectionViewLayout : UICollectionViewFlowLayout

#pragma mark - Layout Properties



#pragma mark - Dragging Properties

/**
 * Center of the cell being dragged. Set this to update it's center.
 */
@property (nonatomic) CGPoint draggedCellCenter;



@end
