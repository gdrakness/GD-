
//
//  GDTableViewSaturdayCell.m
//  GD超次元
//
//  Created by gdarkness on 16/7/24.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import "GDTableViewSaturdayCell.h"
#import "GDTimeCollectionViewCell.h"

#import "GDHomeManager.h"
#import "GDTimeTableModel.h"
#import "LORequestManger.h"

@interface GDTableViewSaturdayCell ()
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)UIView *view;
@property(nonatomic,strong)NSMutableArray<GDTimeTableDescModel *> *sat;
@end

@implementation GDTableViewSaturdayCell
static NSString *Identifier = @"GDTimeCollectionViewCell6";


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _view = [[UIView alloc]initWithFrame:CGRectMake(40, 5, [UIScreen mainScreen].bounds.size.width - 45, 350)];
        //        _view.backgroundColor = blueColor;
        [self.contentView addSubview:_view];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(19,7,3,_view.frame.size.height + 20)];
        lineView.backgroundColor = BlueColor;
        [self.contentView addSubview:lineView];
        
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 33, 30)];
        _image.backgroundColor = [UIColor whiteColor];
        [_image setImage:[UIImage imageNamed:@"sat"]];
        [self.contentView addSubview:_image];
        
        [self getCollection];
    }
    return self;
}

-(void)getCollection{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((WIDTH - 18) / 4, (HEIGHT + 60) / 4);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _view.bounds.size.width, _view.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[GDTimeCollectionViewCell class] forCellWithReuseIdentifier:Identifier];
    [_view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.sat.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GDTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    
    GDTimeTableDescModel *cellItme = self.sat[indexPath.item];
    [cell setModel:cellItme];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GDTimeTableDescModel *cellItme = self.sat[indexPath.item];
    if ([_delegate respondsToSelector:@selector(getSaturdayTableViewPushDetailsViewControllerWithURL:)]) {
        [_delegate getSaturdayTableViewPushDetailsViewControllerWithURL:cellItme.url];
    }
}

-(NSMutableArray<GDTimeTableDescModel *> *)sat{
    
    if (_sat != nil) {
        return _sat;
    }
    //实例化
    _sat = [NSMutableArray array];
    
    [LORequestManger GET:TimeURL parame:nil success:^(id response) {
        
        [GDTimeTableModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"sat":@"GDTimeTableDescModel"
                     };
        }];
        GDTimeTableModel *dataModel = [GDTimeTableModel mj_objectWithKeyValues:response];
        [self.sat addObjectsFromArray:dataModel.sat];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    return _sat;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
