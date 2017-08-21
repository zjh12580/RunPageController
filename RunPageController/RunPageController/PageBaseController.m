//
//  PageBaseController.m
//  RunPageController
//
//  Created by zhaojh on 2017/8/21.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "PageBaseController.h"

@interface PageBaseController ()

@end

@implementation PageBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.viewDidAppearBlock) {
        self.viewDidAppearBlock(self.pageType);
    }
}

@end
