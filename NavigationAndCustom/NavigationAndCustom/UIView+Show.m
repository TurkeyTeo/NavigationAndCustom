//
//  UIView+Show.m
//  NavigationAndCustom
//
//  Created by Thinkive on 2017/8/8.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "UIView+Show.h"

@implementation UIView (Show)

/** 该方法在UIView的分类中实现 */
- (BOOL)isShowingOnKeyWindow
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 把这个view在它的父控件中的frame(即默认的frame)转换成在window的frame
    CGRect convertFrame = [self.superview convertRect:self.frame toView: keyWindow];
    CGRect windowBounds = keyWindow.bounds;
    // 判断这个控件是否在主窗口上（即该控件和keyWindow有没有交叉）
    BOOL isOnWindow = CGRectIntersectsRect(convertFrame, windowBounds);
    // 再判断这个控件是否真正显示在窗口范围内（是否在窗口上，是否为隐藏，是否透明）
    BOOL isShowingOnWindow = (self.window == keyWindow) && !self.isHidden && (self.alpha > 0.01) && isOnWindow;
    return isShowingOnWindow;
}

@end
