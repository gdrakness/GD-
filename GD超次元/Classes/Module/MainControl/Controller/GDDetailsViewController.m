//
//  GDDetailsViewController.m
//  GD超次元
//
//  Created by gdarkness on 16/6/22.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import "GDDetailsViewController.h"
#import "GDVideoDetailsTableViewCell.h"
#import "GDVideoBluesTableViewCell.h"
#import "GDDetailsDataModel.h"
#import "LORequestManger.h"


@interface GDDetailsViewController ()
@property(nonatomic,strong)GDDetailsDataModel *detailsModel;
@property(nonatomic,strong)UIView *detailsView;
@property(nonatomic,strong)UIButton *labBtn;
@end

@implementation GDDetailsViewController

static NSString *fIdentifier = @"fDetailsView";
static NSString *sIdentifier = @"sDetailsView";

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor grayColor];
    [self.tableView registerClass:[GDVideoDetailsTableViewCell class] forCellReuseIdentifier:fIdentifier];
    [self.tableView registerClass:[GDVideoBluesTableViewCell class] forCellReuseIdentifier:sIdentifier];
    self.tableView.backgroundColor = [UIColor colorWithRed:236 / 255.0f green:239 / 255.0f blue:243 / 255.0f alpha:1];
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getDataIsMore:NO];
    
    self.tableView.scrollEnabled = NO;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 170;
        
    }else if (indexPath.section == 1){
        
        return 250;
    }
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  10;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.row == 0) {
//        return 200;
//    }
//    return 150;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GDVideoDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fIdentifier];
        GDDetailsDataModel *cellItem = self.detailsModel;
        [cell setModel:cellItem];
        return cell;
    }else{
        GDVideoBluesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
        cell.url = _url;
    
        return cell;
    }
}

-(void)getDataIsMore:(BOOL)isMore{
    
    [LORequestManger GET:_url parame:nil success:^(id response) {
        
        GDDetailsDataModel *dataModel = [GDDetailsDataModel mj_objectWithKeyValues:response];
        self.detailsModel = dataModel;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
