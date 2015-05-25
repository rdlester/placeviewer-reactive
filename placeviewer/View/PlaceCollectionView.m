#import "PlaceCollectionView.h"

#import <ReactiveCocoa.h>

#import "PlaceArray.h"
#import "PlaceCell.h"

@interface PlaceCollectionView () <UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout>
@end

@implementation PlaceCollectionView

+ (UICollectionViewFlowLayout *)flowLayoutForPlaceCollectionView {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumLineSpacing = 2;
  return layout;
}

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithFrame:frame collectionViewLayout:layout];
  if (self) {
    self.backgroundColor = [UIColor grayColor];

    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[PlaceCell class] forCellWithReuseIdentifier:[PlaceCell identifier]];
  }
  return self;
}

- (void)setPlaceArray:(PlaceArray *)placeArray {
  @weakify(self);
  _placeArray = placeArray;
  [_placeArray.currentPlacesUpdated subscribeNext:^(id x) {
    @strongify(self);
    [self reloadData];
  }];
  [self reloadData];
}

//- (void)setPlacesToDisplay:(NSArray *)placesToDisplay {
//  _placesToDisplay = placesToDisplay;
//  [self reloadData];
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _placeArray.currentPlaces.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PlaceCell *cell = [self dequeueReusableCellWithReuseIdentifier:[PlaceCell identifier]
                                                    forIndexPath:indexPath];
  cell.place = _placeArray.currentPlaces[indexPath.item];
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(CGRectGetWidth(self.frame), [PlaceCell expectedHeight]);
}

@end
