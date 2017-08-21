//
//  PageBaseController.h
//  RunPageController
//
//  Created by zhaojh on 2017/8/21.
//  Copyright © 2017年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageBaseController : UIViewController

@property(nonatomic,assign) NSInteger pageType;

@property(nonatomic,copy)void(^viewDidAppearBlock)(NSInteger index);


@end
