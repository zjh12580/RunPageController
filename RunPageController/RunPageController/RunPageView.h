//
//  RunPageView.h
//  ChineseCultureProject
//
//  Created by zhaojh on 17/7/1.
//  Copyright © 2017年 com.pipixia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RunPageViewDelegate <NSObject>

-(void)pageViewSelectAtIndex:(NSInteger)idnex;

@end

@interface RunViewModel : NSObject

@property(nonatomic,assign)NSInteger lineHeight;
@property(nonatomic,assign)NSInteger lineWidth;
@property(nonatomic,assign)NSInteger lineBottomSpace;

@property(nonatomic,strong)UIColor* lineNormalColor;
@property(nonatomic,strong)UIColor* lineSelectColor;

@property(nonatomic,strong)UIColor* selectColor;
@property(nonatomic,strong)UIColor* normalColor;

@property(nonatomic,strong)UIFont* titleNormalFont;
@property(nonatomic,strong)UIFont* titleSelectFont;

@end

@interface RunPageView : UIView

-(instancetype)initWithFrame:(CGRect)frame config:(RunViewModel*)model;

@property(nonatomic,weak)id<RunPageViewDelegate> delegate;

@property(nonatomic,strong)NSArray* titles;

-(void)scrollViewDidScroll:(CGFloat)offSetX;

@property(nonatomic,assign)NSInteger pageIndex;

@end


