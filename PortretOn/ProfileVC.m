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
static int headerHeight = 300;

typedef NS_ENUM(NSUInteger, LayoutStates) {
    DefaultStateLayout,
    TableStateLayout,
    MapStateLayout,
    GalleryStateLayout
};

@interface ProfileVC ()
@property (nonatomic) int step;
@property (nonatomic) LayoutStates currentState;
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
    if (self.collectionView.isHidden) {
        self.collectionView.hidden = NO;
    }
    if (self.indicator.animating) {
        [self.indicator stopAnimating];
    }
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
    NSArray *currentPhotoUrl = [NSArray array];
    if (self.currentState == 0) {
        currentPhotoUrl = [WebServiceManager sharedInstance].userPhotoUrlArray;
    } else {
        currentPhotoUrl = [WebServiceManager sharedInstance].userStandartPhotoUrlArray;
    }
    [cell populateCollectionCellWith:currentPhotoUrl[cellNumber] cellNumber:cellNumber state:self.currentState];
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
            [header populateCellWith:[WebServiceManager sharedInstance].userDataDictionary delegateWith:self];
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
        CGSize size = CGSizeMake(screenWidth, headerHeight);
        return size;
    } else {
        return CGSizeZero;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self returtCurrentItemSize];
}

- (CGSize)returtCurrentItemSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0 - 1;
    switch (self.currentState) {
        case DefaultStateLayout: {
            return CGSizeMake(cellWidth, cellWidth);
            break;
        }
        case TableStateLayout: {
            return CGSizeMake(screenWidth, screenWidth);
            break;
        }
        default: {
            return CGSizeMake(cellWidth, cellWidth);
            break;
        }
    }
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

#pragma mark - Notification and properties
- (void)startNoticicationProcess {
    self.step = 0;
    self.currentState = DefaultStateLayout;
    [self.indicator startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationFillCollectionView)
                                                 name:@"userMediaNotification"
                                               object:nil];
    [[WebServiceManager sharedInstance] sendRequestForUserMedia];
}

- (void) notificationFillCollectionView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(reloadMyCollView) withObject:nil afterDelay:0.1];
    });
}

#pragma mark - CollcetionView Layouts Control



- (void)changeLayoutState:(NSNumber *)stateIdButton {
    self.currentState = [stateIdButton intValue];
     NSLog(@"layout state == %zd", self.currentState);
    switch (self.currentState) {
        case 2:
            NSLog(@"Not ready");
            return;
        case 3:
            NSLog(@"Not ready");
            return;            
        default:
            [self reloadMyCollView];
            break;
    }
}

@end
