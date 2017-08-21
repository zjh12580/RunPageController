//
//  RunPageView.m
//  ChineseCultureProject
//
//  Created by zhaojh on 17/7/1.
//  Copyright © 2017年 com.pipixia. All rights reserved.
//

#import "RunPageView.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface RunPageView ()

@property(nonatomic,strong)UIView* runView;

@property(nonatomic,assign)BOOL isClickedStatu;

@property(nonatomic,strong)RunViewModel* configuration;

@end

@implementation RunPageView

-(instancetype)initWithFrame:(CGRect)frame config:(RunViewModel*)model{

    if (self = [super initWithFrame:frame]) {
        
        self.configuration = model;
    }
    return self;
    
}

-(void)setConfiguration:(RunViewModel *)configuration{
    _configuration = configuration;
    
    [self settingModel];
}
-(void)settingModel{

    if (!_configuration.lineNormalColor) {
        _configuration.lineNormalColor = [UIColor blackColor];
    }
    if (!_configuration.lineSelectColor) {
        _configuration.lineSelectColor = [UIColor blackColor];
    }
    if (!_configuration.lineWidth) {
        _configuration.lineWidth = 30;
    }
    if (_configuration.lineHeight == 0) {
        _configuration.lineHeight = 2;
    }
    if (!_configuration.titleNormalFont) {
        _configuration.titleNormalFont = [UIFont systemFontOfSize:16];
    }
    if (!_configuration.titleSelectFont) {
        _configuration.titleSelectFont = [UIFont systemFontOfSize:17];
    }
    if (!_configuration.normalColor) {
        _configuration.normalColor = [UIColor blackColor];
    }
    if (!_configuration.selectColor) {
        _configuration.selectColor = [UIColor blackColor];
    }

}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self removeAllSubviews];
    
    //下划线
    _runView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 3 - self.configuration.lineHeight, self.configuration.lineWidth, self.configuration.lineHeight)];
    _runView.layer.cornerRadius = _runView.height / 2;
    _runView.backgroundColor = self.configuration.lineNormalColor;

    [self addSubview:_runView];
    
    CGFloat itemWidth = self.width / titles.count;
    CGFloat itemHeight = self.height;
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton* titleSender = [UIButton buttonWithType:UIButtonTypeCustom];
        titleSender.frame = CGRectMake(itemWidth * idx, 0, itemWidth, itemHeight);
        titleSender.centerY = self.height / 2;
        
        titleSender.tag = 160 + idx;
        titleSender.titleLabel.font = self.configuration.titleNormalFont;
        [titleSender setTitle:obj forState:0];
        [titleSender setTitleColor:self.configuration.normalColor forState:0];
        [titleSender setTitleColor:self.configuration.selectColor forState:UIControlStateSelected];
        [titleSender addTarget:self action:@selector(titleSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:titleSender];
        
        if (idx == 0) {
            _runView.centerX = titleSender.centerX;
            titleSender.selected = YES;
        }
    }];
}

#pragma mark - ScrollViewDELEGATE

-(void)scrollViewDidScroll:(CGFloat)offSetX{
    
    if (self.pageIndex == self.titles.count - 1 && offSetX > KScreenWidth) {return; }
    if (self.pageIndex == 0 && offSetX < KScreenWidth) {return;}
    if (_isClickedStatu) { return; }
    
    CGFloat maxRunViewWidth = self.width / self.titles.count; //一个最长的runview 宽度
    CGFloat needScrollWith = KScreenWidth / 2;                 //一个最长runview宽度vc所需滑动的距离
    UIButton* sender = [self viewWithTag:self.pageIndex + 160];
    UIButton* nextSender = [self viewWithTag:self.pageIndex + 1 + 160];
    CGFloat RunViewWidth = self.configuration.lineWidth;
    
    
    CGRect frame = _runView.frame;
    //(向右走)显示右边的
    if (offSetX > KScreenWidth) {
        
        if (offSetX <= KScreenWidth * 3 / 2) {
            
            frame.origin.x = sender.centerX - RunViewWidth / 2;
            CGFloat width = RunViewWidth + (offSetX - KScreenWidth) / needScrollWith * maxRunViewWidth;
            frame.size.width = MAX(width, RunViewWidth);
            
        }else{
            
            CGFloat scrollScale = (offSetX - (KScreenWidth * 3 / 2)) / needScrollWith;
            CGFloat width = maxRunViewWidth + RunViewWidth - scrollScale * maxRunViewWidth;
            frame.size.width = MAX(width, RunViewWidth);
            
            CGFloat maxX = nextSender.centerX + RunViewWidth / 2;
            frame.origin.x = maxX - width;
        }
    }else{ //(向左走)
        
        if (offSetX <= 0) {
            offSetX = 0;
        }
        if (offSetX >= KScreenWidth / 2) {
            
            CGFloat width = RunViewWidth + (KScreenWidth - offSetX) / needScrollWith * maxRunViewWidth;;
            frame.size.width = MAX(width, RunViewWidth);
            
            CGFloat maxX = sender.centerX + RunViewWidth / 2;
            frame.origin.x = maxX - frame.size.width;
        }else{
            
            frame.origin.x = sender.centerX - maxRunViewWidth - RunViewWidth / 2;
            
            CGFloat width = maxRunViewWidth + RunViewWidth - (needScrollWith - offSetX) / needScrollWith * maxRunViewWidth;
            frame.size.width = MAX(width, RunViewWidth);
        }
    }
    _runView.frame = frame;

}

-(void)setPageIndex:(NSInteger)pageIndex{
    _pageIndex = pageIndex;
    
    UIButton* sender = [self viewWithTag:self.pageIndex + 160];
    sender.selected = YES;
    sender.titleLabel.font = self.configuration.titleSelectFont;
    _runView.backgroundColor = self.configuration.lineSelectColor;
    
    [UIView animateWithDuration:.2 animations:^{
       _runView.centerX = sender.centerX;
        _runView.width = self.configuration.lineWidth;
    }];
   
    //找到上一个button置为非选
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag != sender.tag) {
            
            UIButton* button = (UIButton*)view;
            button.selected = NO;
            button.titleLabel.font = self.configuration.titleNormalFont;
        }
    }
}
#pragma mark - Action
-(void)titleSelectAction:(UIButton*)sender{
    
    self.isClickedStatu = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isClickedStatu = NO;
    });
    _pageIndex = sender.tag - 160;
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewSelectAtIndex:)]) {
        [_delegate pageViewSelectAtIndex:sender.tag - 160];
    }
}


@end

@implementation RunViewModel

@end
