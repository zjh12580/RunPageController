//
//  ViewController.m
//  RunPageController
//
//  Created by zhaojh on 2017/8/21.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "ViewController.h"
#import "PageController1.h"
#import "PageController2.h"
#import "PageController3.h"
#import "RunPageView.h"
#import "PageBaseController.h"


@interface ViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource,RunPageViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIPageViewController* pageViewController;
@property(nonatomic,strong)NSArray* myControllers;
@property(nonatomic,strong)RunPageView* pageControlView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _myControllers = [self pageVCs];
    [self setupPageController];
    [self setupPageViewTopBar];
    [self pageViewSelectAtIndex:0];
}

-(void)setupPageController{
    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(0)};
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    CGRect frame = self.view.bounds;
    _pageViewController.view.frame = frame;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
}
-(NSArray*)pageVCs{
    
    __weak typeof(ViewController*) weakSelf = self;
    void(^viewDidAppearBlock)(NSInteger index) = ^(NSInteger pageIndex){
        weakSelf.pageControlView.pageIndex = pageIndex;
    };
    PageController1* vc1 = [[PageController1 alloc] init];
    vc1.pageType = 0;
    vc1.viewDidAppearBlock = viewDidAppearBlock;
    
    PageController2* vc2 = [[PageController2 alloc] init];
    vc2.pageType = 1;
    vc2.viewDidAppearBlock = viewDidAppearBlock;
    
    PageController3* vc3 = [[PageController3 alloc] init];
    vc3.pageType = 2;
    vc3.viewDidAppearBlock = viewDidAppearBlock;
    
    NSArray* vcs = @[vc1,vc2,vc3];
    
    return vcs;
}

#pragma mark - 下划线
-(void)setupPageViewTopBar{
    
    RunViewModel* model = [[RunViewModel alloc] init];
    model.lineHeight = 3;
    model.lineWidth = 35;
    model.lineBottomSpace = 0;
    model.lineNormalColor = [UIColor blackColor];
    model.lineSelectColor = [UIColor orangeColor];
    model.titleNormalFont = [UIFont systemFontOfSize:18];
    model.titleSelectFont = [UIFont systemFontOfSize:18];
    model.selectColor = [UIColor orangeColor];;
    _pageControlView = [[RunPageView alloc] initWithFrame:CGRectMake(0, 0, 220, 40) config:model];
    
    _pageControlView.titles = @[@"头条",@"热点",@"科技"];
    _pageControlView.delegate = self;
    
    for (UIView* view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            scrollView.delegate = self;
        }
    }
    self.navigationItem.titleView = _pageControlView;
}

-(void)pageViewSelectAtIndex:(NSInteger)idnex{
    
    [_pageViewController setViewControllers:@[_myControllers[idnex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
#pragma mark - PageController Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    PageBaseController* vc = (PageBaseController*)viewController;
    
    if (vc.pageType == 0) {
        return nil;
    }
    return self.myControllers[vc.pageType - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    PageBaseController* vc = (PageBaseController*)viewController;
    
    if (vc.pageType >= self.myControllers.count - 1) {
        return nil;
    }
    return self.myControllers[vc.pageType + 1];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offSetX = scrollView.contentOffset.x;
    [self.pageControlView scrollViewDidScroll:offSetX];
}



@end
