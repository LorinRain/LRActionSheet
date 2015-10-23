//
//  LRActionSheet.h
//  LRActionSheet
//
//  Created by Lorin on 15/10/21.
//  Copyright © 2015年 LorinRain. All rights reserved.
//  提示框

#import <UIKit/UIKit.h>

@class LRActionSheet;

@protocol LRActionSheetDelegate <NSObject>

@optional
/*
 * @brief 按钮点击事件
 * 按钮点击的时候，提示框自动消失
 */
- (void)actionSheet:(LRActionSheet *)actionSheet buttonClickedAtIndex:(NSInteger)index;

@end


@interface LRActionSheet : UIView

///毁灭性按钮的index
@property (nonatomic) NSInteger destructiveButtonIndex;

///代理
@property (nonatomic, assign) id<LRActionSheetDelegate>delegate;

/*
 * 初始化方法
 * @brief 初始的时候指定标题以及按钮
 * @param others传入一个数组，数组内容为NSString
 */
- (instancetype)initWithTitle:(NSString *)title destroyButtonTitle:(NSString *)destroyTitle otherButtonTitles:(NSArray *)others;

///显示
- (void)show;

@end
