//
//  NavAnimationWrapper.m
//  NavigationAndCustom
//
//  Created by Thinkive on 2017/8/9.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "NavAnimationWrapper.h"

@interface NavAnimationWrapper ()

@property(nonatomic,strong)NSMutableArray * screenShotArray;
/**
 所属的导航栏有没有TabBarController
 */
@property (nonatomic,assign)BOOL isTabbarExist;

@end


@implementation NavAnimationWrapper


+ (instancetype)navAnimationWrapperWithOperation:(UINavigationControllerOperation)operation NavigationController:(UINavigationController *)navigationController{
    NavAnimationWrapper *navAW = [[NavAnimationWrapper alloc] init];
    navAW.navigationController = navigationController;
    navAW.navigationOperation = operation;
    return navAW;
}

- (void)setNavigationController:(UINavigationController *)navigationController{
    _navigationController = navigationController;
    
    UIViewController *mayTabbarVC = self.navigationController.view.window.rootViewController;
    //判断该导航栏是否有TabBarController
    if (self.navigationController.tabBarController == mayTabbarVC) {
        _isTabbarExist = YES;
    }else{
        _isTabbarExist = NO;
    }
}

- (NSMutableArray *)screenShotArray{
    if (!_screenShotArray) {
        _screenShotArray = [NSMutableArray array];
    }
    return _screenShotArray;
}

#pragma mark -- UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .4f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIImageView * screenImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImage *screenImage = [self screenShot];
    screenImgView.image = screenImage;
    
    //取出fromViewController,fromView和toViewController，toView
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
    fromViewFinalFrame.origin.x = ScreenWidth;
    CGRect fromViewStartFrame = fromViewFinalFrame;
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect toViewStartFrame = toViewFinalFrame;

    UIView *containerView = [transitionContext containerView];
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        [self.screenShotArray addObject:screenImage];
        //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
        [containerView addSubview:toView];
        
        toView.frame = toViewStartFrame;
        
        UIView * nextVC = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        
        //将截图添加到导航栏的View所属的window上
        [self.navigationController.view.window insertSubview:screenImgView atIndex:0];
        
        nextVC.layer.shadowColor = [UIColor blackColor].CGColor;
        nextVC.layer.shadowOffset = CGSizeMake(-0.8, 0);
        nextVC.layer.shadowOpacity = 0.6;
        
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //toView.frame = toViewEndFrame;
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screenImgView.center = CGPointMake(-ScreenWidth/2, ScreenHeight / 2);
//            nextVC.center = CGPointMake(ScreenWidth/2, ScreenHeight / 2);
            
            
        } completion:^(BOOL finished) {
            
            [nextVC removeFromSuperview];
            [screenImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }else if (self.navigationOperation == UINavigationControllerOperationPop) {
        
        fromViewStartFrame.origin.x = 0;
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        //若removeCount大于0  则说明Pop了不止一个控制器
        if (_removeCount > 0) {
            for (NSInteger i = 0; i < _removeCount; i ++) {
                if (i == _removeCount - 1) {
                    //当删除到要跳转页面的截图时，不再删除，并将该截图作为ToVC的截图展示
                    lastVcImgView.image = [self.screenShotArray lastObject];
                    _removeCount = 0;
                    break;
                }
                else
                {
                    [self.screenShotArray removeLastObject];
                }
                
            }
        }else{
            lastVcImgView.image = [self.screenShotArray lastObject];
        }
        
        screenImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screenImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screenImgView.layer.shadowOpacity = 0.6;
        [self.navigationController.view.window addSubview:lastVcImgView];
        [self.navigationController.view addSubview:screenImgView];
        
        // fromView.frame = fromViewStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screenImgView.center = CGPointMake(ScreenWidth * 3 / 2 , ScreenHeight / 2);
            lastVcImgView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            //fromView.frame = fromViewEndFrame;
            
        } completion:^(BOOL finished) {
            //[self.navigationController setNavigationBarHidden:NO];
            [lastVcImgView removeFromSuperview];
            [screenImgView removeFromSuperview];
            [self.screenShotArray removeLastObject];
            [transitionContext completeTransition:YES];
        }];
    }
}

//截图
- (UIImage *)screenShot{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    UIViewController *rootVC = self.navigationController.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = rootVC.view.frame.size;
    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    if (_isTabbarExist) {
        [rootVC.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }else{
        [self.navigationController.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();

    return snapshot;
}

- (void)removeLastScreenShot
{
    [self.screenShotArray removeLastObject];
}

- (void)removeAllScreenShot
{
    [self.screenShotArray removeAllObjects];
}

- (void)removeLastScreenShotWithNumber:(NSInteger)number
{
    for (NSInteger  i = 0; i < number ; i++) {
        [self.screenShotArray removeLastObject];
    }
}



@end
