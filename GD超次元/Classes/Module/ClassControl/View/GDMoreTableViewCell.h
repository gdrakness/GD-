//
//  GDMoreTableViewCell.h
//  GD超次元
//
//  Created by gdarkness on 16/8/15.
//  Copyright © 2016年 gdarkness. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDMoreDataModel;

@interface GDMoreTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *pictureView;

-(void)setModel:(GDMoreDataModel *)model;
@end
