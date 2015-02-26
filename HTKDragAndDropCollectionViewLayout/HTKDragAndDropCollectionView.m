//
//  HTKDragAndDropCollectionViewController.m
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

#import "HTKDragAndDropCollectionView.h"

@interface HTKDragAndDropCollectionView ()

@property (strong, nonatomic) HTKDragAndDropCollectionViewLayout *layout;

/**
 * Helper method that will scroll the collectionView up or down
 * based on if the cell being dragged is out of it's visible bounds or not.
 * Defaults to 10pt buffer and moves 1pt at a time. It will "speed up" when
 * you drag the cell further past the 10pt buffer.
 */
- (void)scrollIfNeededWhileDraggingCell:(UICollectionViewCell *)cell;

@end

@implementation HTKDragAndDropCollectionView


#pragma mark - accessors

-(HTKDragAndDropCollectionViewLayout *) layout {
    if (!_layout) {
        _layout = (HTKDragAndDropCollectionViewLayout *) self.collectionViewLayout;
    }
    return _layout;
}


#pragma mark - initializer

- (id) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - HTKDraggableCollectionViewCellDelegate

- (void)userWillDragCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    self.draggedIndexPath = [self indexPathForCell:cell];
    [self.layout invalidateLayout];
}

- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIPanGestureRecognizer *)recognizer{
    
    self.intersectPath = [self indexPathForItemAtPoint:cell.center];
    
    //NSLog(@"intersectPath %li", (long)self.intersectPath.item);
    //NSLog(@"intersectAttributes %@", self.intersectAttributes.description);
    
    
    if (self.intersectPath != nil && ![self.intersectPath isEqual:self.draggedIndexPath]) {
        // Create a "hit area" that's 20 pt over the center of the intersected cell center
        CGPoint intersectOrigin = [self layoutAttributesForItemAtIndexPath:self.intersectPath].frame.origin;
        CGRect centerBox = CGRectMake(intersectOrigin.x, intersectOrigin.y, 200.0, 200.0);

        // Determine if we need to move items around
        if ( CGRectContainsPoint(centerBox, cell.center)) {
            // Animate change
            [UIView animateWithDuration:0.5 animations:^{
                [self.HTKDragAndDropCollectionViewDelegate moveItemAtIndexPath:self.draggedIndexPath toIndexPath:self.intersectPath];
                [self moveItemAtIndexPath:self.draggedIndexPath toIndexPath:self.intersectPath];
            }];
            
            self.intersectPath = nil;
            self.draggedIndexPath = nil;
        }
    } else {
        // Animate change
        [UIView animateWithDuration:0.5 animations:^{
            cell.center = [self layoutAttributesForItemAtIndexPath:self.draggedIndexPath].center;
            //FYI moveItemAtIndexPath:self.draggedIndexPath toIndexPath: bug when move the same item twice
            //[self moveItemAtIndexPath:self.draggedIndexPath toIndexPath:self.draggedIndexPath];
        }];
        self.draggedIndexPath = nil;
    }
}

- (void)userDidDragCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self];
    // Determine the new center of the cell
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y + translation.y);

    cell.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self];

    // Scroll down if we're holding cell off screen vertically
    // [self scrollIfNeededWhileDraggingCell:draggedCell];
}

#pragma mark - Helper Methods

- (void)scrollIfNeededWhileDraggingCell:(UICollectionViewCell *)cell {
    
    HTKDragAndDropCollectionViewLayout *flowLayout = (HTKDragAndDropCollectionViewLayout *)self.collectionViewLayout;

    CGPoint cellCenter = flowLayout.draggedCellCenter;
    // Offset we will be adjusting
    CGPoint newOffset = self.contentOffset;
    // How far past edge does it need to be before scrolling
    CGFloat buffer = 10;
    
    // Check for scrolling down
    CGFloat bottomY = self.contentOffset.y + CGRectGetHeight(self.frame);
    if (bottomY < CGRectGetMaxY(cell.frame) - buffer) {
        // We're scrolling down
        newOffset.y += 1;
        
        if (newOffset.y + CGRectGetHeight(self.bounds) > self.contentSize.height) {
            return; // Stop moving, went too far
        }
        
        // adjust cell's center by 1
        cellCenter.y += 1;
    }
    
    // Check if moving upwards
    CGFloat offsetY = self.contentOffset.y;
    if (CGRectGetMinY(cell.frame) + buffer < offsetY) {
        // We're scrolling up
        newOffset.y -= 1;
        
        if (newOffset.y <= 0) {
            return; // Stop moving, went too far
        }
        
        // adjust cell's center by 1
        cellCenter.y -= 1;
    }
    
    // Set new values
    self.contentOffset = newOffset;
    flowLayout.draggedCellCenter = cellCenter;
    // Repeat until we went to far.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollIfNeededWhileDraggingCell:cell];
    });
}

@end
