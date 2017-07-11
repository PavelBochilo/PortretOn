//
//  ProfileVC.m
//  PortretOn
//
//  Created by Pavel Bochilo on 06.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "ProfileVC.h"
#import "HomeTableCell.h"
#import "HeaderReusCell.h"
#import "MainCollectionReusableView.h"


static NSString *headerId = @"HeaderReusCell";
static NSString *photoCell = @"MainCollectionReusableView";

@interface ProfileVC ()
@property (nonatomic) int step;
@end

@implementation ProfileVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self startNoticicationProcess];
    [self registerAllNibs];
    [self setNavigationBarWithTitle:
     [[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.full_name"]];
}

- (void)registerAllNibs {
    UINib *nib = [UINib nibWithNibName:@"HeaderReusCell"
                                bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerId];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}


- (void)reloadMyCollView {
    self.step = 1;
    [self.collectionView reloadData];
    [self.indicator stopAnimating];
}

#pragma mark - CollcetionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
        return [WebServiceManager sharedInstance].userPhotoUrlArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int cellNumber = (int)indexPath.row;
    NSString *currentId = [[NSString alloc] initWithFormat: @"collectionCell_%d", cellNumber];
    [self.collectionView registerNib:[UINib nibWithNibName:photoCell bundle:nil] forCellWithReuseIdentifier:currentId];
    
    [self.collectionView dequeueReusableCellWithReuseIdentifier:currentId forIndexPath:indexPath];
    MainCollectionReusableView *cell = (MainCollectionReusableView *)[collectionView
                                                                      dequeueReusableCellWithReuseIdentifier:currentId
                                                                                                forIndexPath:indexPath];
    [cell populateCollectionCellWith:[WebServiceManager sharedInstance].userPhotoUrlArray[cellNumber]
                          cellNumber:cellNumber];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            HeaderReusCell *header = (HeaderReusCell *)[self.collectionView
                                                        dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:headerId
                                                                                  forIndexPath:indexPath];
            [header populateCellWith:[WebServiceManager sharedInstance].userMediaDictionary delegateWith:self];
            return header;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGSize size = CGSizeMake(screenWidth, 250);
        return size;
    } else {
        return CGSizeZero;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0 - 1;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}


- (void)startNoticicationProcess {
    self.step = 0;
    [self.indicator startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationFillCollectionView)
                                                 name:@"userMediaNotification"
                                               object:nil];
    [[WebServiceManager sharedInstance] sendRequestForUserMedia];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) notificationFillCollectionView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(reloadMyCollView) withObject:nil afterDelay:0.1];
    });
}

@end
