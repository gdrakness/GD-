//
//  GDFavritesViewController.m
//  GD超次元
//
//  Created by gdarkness on 16/8/18.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import "GDFavritesViewController.h"
#import "GDFavoritesDataMoel.h"
#import "LORequestManger.h"
#import "GDHomeManager.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "GDLerderBoradTableViewCell.h"

@interface GDFavritesViewController ()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NewPagedFlowView *pageFlowView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSMutableArray<GDFaovritesRequestData *> *data;
@property(nonatomic,strong)NSMutableArray<GDLeaderBoardRequestData *> *LeaderData;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headerView;
@end

@implementation GDFavritesViewController
static NSString *Identifier = @"GDFavritesViewController";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 5, 70)];
    imageView.image = [UIImage imageNamed:@"new_logo"];
    self.navigationItem.titleView = imageView;
    
    [self setupTableView];
    [self getDataIsMore:NO];
    [self getLeaderBoradDataIsMore:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(prepareUI) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_pageFlowView stopTimer];
    [_pageFlowView removeFromSuperview];
    [_pageControl removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataIsMore:(BOOL)isMore{
    
   [LORequestManger GET:PageFlowURL parame:nil success:^(id response) {
       
       [GDFavoritesDataMoel mj_setupObjectClassInArray:^NSDictionary *{
           return@{
                   @"data":@"GDFaovritesRequestData"
                   };
       }];
       GDFavoritesDataMoel *dataMoel = [GDFavoritesDataMoel mj_objectWithKeyValues:response];
       [self.data addObjectsFromArray:dataMoel.data];
       
       [self prepareUI];
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
   }];
}

-(void)getLeaderBoradDataIsMore:(BOOL)isMore{
    
    [[GDHomeManager shareInstance]getFindLeadeBoardRequestWithURL:nil success:^(GDLeaderBoardDataModel *dataModel) {
        
        [self.LeaderData addObjectsFromArray:dataModel.data];
        [_tableView reloadData];
        
    } error:^(NSError *error) {
        
    }];
}



-(void)prepareUI{
    
    _pageFlowView = [[NewPagedFlowView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.width - 84) * 9 / 18 + 20)];
    _pageFlowView.backgroundColor = GrayColor;
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.4;
    _pageFlowView.minimumPageScale = 0.85;
    _pageFlowView.orginPageCount = self.data.count;

    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _pageFlowView.height - 20, self.view.width, 8)];
    _pageControl.currentPageIndicatorTintColor = blueColor;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.userInteractionEnabled = NO;
    _pageFlowView.pageControl = _pageControl;
    [_pageFlowView addSubview:_pageControl];
    [_pageFlowView startTimer];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [bottomScrollView addSubview:_pageFlowView];
    
    [_headerView addSubview:bottomScrollView];
    

    
    
}

-(void)setupTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [_tableView registerClass:[GDLerderBoradTableViewCell class] forCellReuseIdentifier:Identifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,(self.view.width - 84) * 9 / 18 + 20)];
    _tableView.tableHeaderView = _headerView;
    
    [self.view addSubview:_tableView];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.LeaderData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GDLeaderBoardRequestData *cellRow = self.LeaderData[indexPath.row];
    
    GDLerderBoradTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    [cell setModel:cellRow];
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView{
    return CGSizeMake(self.view.width - 84, (self.view.width - 84) * 9 / 16);
}

-(void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex{
    
}

-(NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView{
    
    return self.data.count;
}

-(UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannserView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannserView) {
        bannserView = [[PGIndexBannerSubiew alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 84, (self.view.width - 84)* 9 / 16)];
        bannserView.layer.cornerRadius = 5;
        bannserView.layer.masksToBounds = YES;
    }
    GDFaovritesRequestData *imageData = self.data[index];
    [bannserView.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageData.coverImage]];
    
    return bannserView;
}

-(NSMutableArray<GDFaovritesRequestData *> *)data{
    if (_data != nil) {
        return _data;
    }
    //实例化
    _data = [NSMutableArray array];
    
    return _data;
}

-(NSMutableArray<GDLeaderBoardRequestData *> *)LeaderData{
    if (_LeaderData != nil) {
        return _LeaderData;
    }
    //实例化
    _LeaderData = [NSMutableArray array];
    
    return _LeaderData;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
