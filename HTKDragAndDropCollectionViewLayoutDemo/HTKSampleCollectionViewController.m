//
//  HTKSampleCollectionViewController.m
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

#import "HTKSampleCollectionViewController.h"
#import "HTKSampleCollectionViewCell.h"

@interface HTKSampleCollectionViewController ()

/**
 * Sample data array we're reordering
 */
@property (nonatomic, strong) NSMutableArray *mDataArray;

@end

@implementation HTKSampleCollectionViewController

#pragma mark - accessors

-(NSMutableArray *) mDataArray {
    if (!_mDataArray ) {
        _mDataArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < 50; i++) {
            [_mDataArray addObject:[NSString stringWithFormat:@"%lu", i]];
        }
    }
    return _mDataArray;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    HTKDragAndDropCollectionView *collectionView = (HTKDragAndDropCollectionView *)self.collectionView;
    collectionView.HTKDragAndDropCollectionViewDelegate = self;
    

    // Set up collectionView
    /*
    self.collectionView = [[HTKDragAndDropCollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
    // Register cell
    [self.collectionView registerClass:[HTKSampleCollectionViewCell class] forCellWithReuseIdentifier:HTKDraggableCollectionViewCellIdentifier];
    */
    
}

#pragma mark UICollectionView Datasource/Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HTKSampleCollectionViewCell *cell = (HTKSampleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HTKDraggableCollectionViewCellIdentifier forIndexPath:indexPath];
    
    // Set number on cell
    cell.numberLabel.text = self.mDataArray[indexPath.row];
    
    // Set our delegate for dragging
    cell.draggingDelegate = self.collectionView;
    
    return cell;
}

/*
#pragma mark - HTKDraggableCollectionViewCellDelegate

- (BOOL)userCanDragCell:(UICollectionViewCell *)cell {
    // All cells can be dragged in this demo
    return YES;
}

- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell {
    [self.collectionView userDidEndDraggingCell:cell];
    
    HTKDragAndDropCollectionViewLayout *flowLayout = (HTKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    
    // Save our dragging changes if needed
    if (flowLayout.finalIndexPath != nil) {
        // Update datasource
        NSObject *objectToMove = [self.dataArray objectAtIndex:flowLayout.draggedIndexPath.row];
        [self.dataArray removeObjectAtIndex:flowLayout.draggedIndexPath.row];
        [self.dataArray insertObject:objectToMove atIndex:flowLayout.finalIndexPath.row];
    }
}
*/

#pragma mark - HTKDraggableCollectionViewDelegate

-(void) switchItemAtIndexPath:(NSIndexPath *)pathFrom withItemAtIndexPath:(NSIndexPath *)pathTo {
    NSLog(@"switch %li - %li",(long)pathFrom.item, (long)pathTo.item);
    [self.mDataArray exchangeObjectAtIndex:pathFrom.item withObjectAtIndex:pathTo.item];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    id object = [self.mDataArray objectAtIndex:indexPath.item];
    [self.mDataArray removeObjectAtIndex:indexPath.item];
    [self.mDataArray insertObject:object atIndex:newIndexPath.item];
}

@end
