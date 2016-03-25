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
- (void)LRActionSheet:(nonnull LRActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index;

@end


@interface LRActionSheet : UIView

///毁灭性按钮的index
@property (nonatomic, readonly) NSInteger destructiveButtonIndex;

///actionSheet标题
@property (nullable, nonatomic, copy, readonly) NSString *title;

///代理
@property (nullable, nonatomic, assign) id<LRActionSheetDelegate>delegate;

/*
 * 初始化方法
 * @brief 初始的时候指定标题以及按钮
 * @param others传入一个数组，数组内容为NSString
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title destroyButtonTitle:(nullable NSString *)destroyTitle otherButtonTitles:(nullable NSArray *)others;

///显示
- (void)show;

/**
 *  actionSheet对应行的标题
 *
 *  @param index 行
 *
 *  @return 标题
 */
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)index;

@end
