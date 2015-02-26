//
//  HTKDragAndDropCollectionViewLayout.m
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

#import "HTKDragAndDropCollectionViewLayout.h"
#import "HTKDragAndDropCollectionView.h"

@interface HTKDragAndDropCollectionViewLayout ()



@property (strong, nonatomic) HTKDragAndDropCollectionView *HTKDCollectionView;


/**
 * Returns number of items that will fit per row based on fixed
 * itemSize.
 */
@property (readonly, nonatomic) NSInteger numberOfItemsPerRow;

/**
 * Applys the dragging attributes to the attributes passed. Will
 * apply dragging state if the attributes are being dragged. If not, will
 * apply default state.
 */
- (void)applyDragAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;

@end

@implementation HTKDragAndDropCollectionViewLayout


#pragma mark - accessors 

-(HTKDragAndDropCollectionView *) HTKDCollectionView {
    if (!_HTKDCollectionView) {
        _HTKDCollectionView = (HTKDragAndDropCollectionView *) self.collectionView;
    }
    return _HTKDCollectionView;
}

#pragma mark - 

- (void)prepareLayout {
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributesFromSuper = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attribute in attributesFromSuper) {
        [self applyDragAttributes:attribute];
    }
    return attributesFromSuper;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    [self applyDragAttributes:layoutAttributes];
    return layoutAttributes;
}

#pragma mark - Getters

- (NSInteger)numberOfItemsPerRow {
    // Determine how many items we can fit per row
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right - self.sectionInset.left;
    NSInteger numberOfItems = collectionViewWidth / (self.itemSize.width + [self minimumInteritemSpacing]);
    
    return numberOfItems;
}

#pragma mark - Drag and Drop methods

- (void)applyDragAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if ([layoutAttributes.indexPath isEqual:self.HTKDCollectionView.draggedIndexPath]) {
        // Set dragged attributes
        layoutAttributes.zIndex = 1024;
        layoutAttributes.alpha = 0.8;
    } else {
       // Default attributes
        layoutAttributes.zIndex = 0;
        layoutAttributes.alpha = 1.0;
    }
}

- (void)setDraggedCellCenter:(CGPoint)draggedCellCenter {
    _draggedCellCenter = draggedCellCenter;
    [self invalidateLayout];
}

#pragma mark - Helper Methods


@end
