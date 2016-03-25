//
//  LRActionSheet.m
//  LRActionSheet
//
//  Created by Lorin on 15/10/21.
//  Copyright © 2015年 LorinRain. All rights reserved.
//

#import "LRActionSheet.h"

#define SCREENSIZE [UIScreen mainScreen].bounds.size
#define RGBCOLOR(r, g, b) [UIColor colorWithRed: r/255.f green: g/255.f blue: b/255.f alpha: 1]
#define BUTTONMAGIN 10   // 按钮间距

#define kDestroyButtonTag 1001
#define kNormalButtonTag 2002

@implementation LRActionSheet
{
    ///下面的弹出框
    UIView *actionSheetView;
    ///弹出框上半部分
    UIView *actionSheetTopView;
    ///弹出框下半部分
    UIView *actionSheetBottomView;
    ///记录title的数组
    NSMutableArray *titlesArray;
    ///毁灭性的按钮的标题
    NSString * _Nullable destroyButtonTitle;
}

- (instancetype)initWithTitle:(NSString *)title destroyButtonTitle:(NSString *)destroyTitle otherButtonTitles:(NSArray *)others
{
    self = [super init];
    if(self) {
        // 动画方式显示
        CATransition *fadeAnimation = [CATransition animation];
        fadeAnimation.duration = 0.3;
        fadeAnimation.type = kCATransitionReveal;
        [self.layer addAnimation: fadeAnimation forKey: nil];
        // 背景半透明
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.5];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        [tap addTarget: self action: @selector(hide)];
        [self addGestureRecognizer: tap];
        // 添加下面的弹出框
        actionSheetView = [[UIView alloc] init];
        actionSheetView.backgroundColor = RGBCOLOR(230, 230, 230);
        actionSheetView.userInteractionEnabled = YES;
        // 弹出框非交互区域添加事件，防止触发self的tap事件
        UITapGestureRecognizer *actionSheetTap = [[UITapGestureRecognizer alloc] init];
        [actionSheetView addGestureRecognizer: actionSheetTap];
        // 添加动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.2;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [actionSheetView.layer addAnimation: animation forKey: nil];
        [self addSubview: actionSheetView];
        // title数组
        titlesArray = [NSMutableArray array];
        // 弹出框上面添加两部分view
        if(title != nil && ![title isEqual: @""]) {
            actionSheetTopView = [[UIView alloc] init];
            actionSheetTopView.frame = CGRectMake(0, 0, SCREENSIZE.width, 45);
            [actionSheetView addSubview: actionSheetTopView];
            
            // 往上半部分视图上添加标题和取消按钮
            _title = title;
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = title;
            titleLabel.textColor = RGBCOLOR(65, 65, 65);
            titleLabel.font = [UIFont systemFontOfSize: 12.f];
            titleLabel.frame = CGRectMake(0, 0, actionSheetTopView.frame.size.width, actionSheetTopView.frame.size.height);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [actionSheetTopView addSubview: titleLabel];
            
            // 取消按钮
            UIButton *btnCancel = [UIButton buttonWithType: UIButtonTypeCustom];
            //[btnCancel setBackgroundImage: [UIImage imageNamed: @"btn_menu_titile_p.png"] forState: UIControlStateNormal];
            btnCancel.backgroundColor = RGBCOLOR(222, 222, 222);
            btnCancel.layer.cornerRadius = 2;
            btnCancel.layer.masksToBounds = YES;
            btnCancel.layer.borderColor = RGBCOLOR(211, 211, 211).CGColor;
            btnCancel.layer.borderWidth = 0.5;
            btnCancel.frame = CGRectMake(actionSheetTopView.frame.size.width - 5 - 47, 10, 47, 45 - 20);
            [btnCancel setTitle: @"取消" forState: UIControlStateNormal];
            [btnCancel setTitleColor: RGBCOLOR(65, 65, 65) forState: UIControlStateNormal];
            btnCancel.titleLabel.font = [UIFont systemFontOfSize: 12];
            [btnCancel addTarget: self action: @selector(hide) forControlEvents: UIControlEventTouchUpInside];
            [actionSheetTopView addSubview: btnCancel];
            
            // 添加上下分割线
            UIImageView *line = [[UIImageView alloc] init];
            line.backgroundColor = RGBCOLOR(211, 211, 211);
            line.frame = CGRectMake(0, 45, SCREENSIZE.width, 1);
            [actionSheetView addSubview: line];
        }
        
        actionSheetBottomView = [[UIView alloc] init];
        CGFloat height = destroyTitle?(others.count+1)*45+(others.count)*BUTTONMAGIN+BUTTONMAGIN*2:others.count*45+(others.count-1)*BUTTONMAGIN+BUTTONMAGIN*2;
        actionSheetBottomView.frame = CGRectMake(0, actionSheetTopView==nil?0:46, SCREENSIZE.width, height);
        [actionSheetView addSubview: actionSheetBottomView];
        
        // 往下半部分视图上添加按钮
        if(destroyTitle) {
            destroyButtonTitle = destroyTitle;
            // 有毁灭性按钮
            if(others == nil || others.count == 0) {
                // 没有其他按钮
                UIButton *btnDestroy = [UIButton buttonWithType: UIButtonTypeCustom];
                [btnDestroy setBackgroundImage: [UIImage imageNamed: @"btn_menu_red_n.png"] forState: UIControlStateNormal];
                btnDestroy.frame = CGRectMake(20, BUTTONMAGIN, SCREENSIZE.width-20*2, 45);
                [btnDestroy setTitle: destroyTitle forState: UIControlStateNormal];
                btnDestroy.titleLabel.font = [UIFont systemFontOfSize: 15];
                [btnDestroy addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                
                btnDestroy.tag = kDestroyButtonTag;
                
                [actionSheetBottomView addSubview: btnDestroy];
            } else {
                // 有其他按钮，先加载其他按钮
                [titlesArray addObjectsFromArray: others];
                for(NSInteger i = 0;i < others.count;i++) {
                    UIButton *btnNormal = [UIButton buttonWithType: UIButtonTypeCustom];
                    [btnNormal setBackgroundImage: [UIImage imageNamed: @"btn_menu_grey_n.png"] forState: UIControlStateNormal];
                    btnNormal.frame = CGRectMake(20, BUTTONMAGIN*(i+1)+45*i, SCREENSIZE.width-20*2, 45);
                    [btnNormal setTitle: others[i] forState: UIControlStateNormal];
                    btnNormal.titleLabel.font = [UIFont systemFontOfSize: 15];
                    [btnNormal addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                    
                    btnNormal.tag = kNormalButtonTag+i;
                    
                    [actionSheetBottomView addSubview: btnNormal];
                }
                // 然后加载毁灭性按钮
                UIButton *btnDestroy = [UIButton buttonWithType: UIButtonTypeCustom];
                [btnDestroy setBackgroundImage: [UIImage imageNamed: @"btn_menu_red_n.png"] forState: UIControlStateNormal];
                btnDestroy.frame = CGRectMake(20, BUTTONMAGIN*(others.count+1)+45*others.count, SCREENSIZE.width-20*2, 45);
                [btnDestroy setTitle: destroyTitle forState: UIControlStateNormal];
                btnDestroy.titleLabel.font = [UIFont systemFontOfSize: 15];
                [btnDestroy addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                
                btnDestroy.tag = kDestroyButtonTag;
                
                [actionSheetBottomView addSubview: btnDestroy];
            }
        } else {
            // 没有毁灭性按钮
            if(others == nil || others.count == 0) {
                // 没有其他按钮
            } else {
                // 有其他按钮，先加载其他按钮
                [titlesArray addObjectsFromArray: others];
                for(NSInteger i = 0;i < others.count;i++) {
                    UIButton *btnNormal = [UIButton buttonWithType: UIButtonTypeCustom];
                    [btnNormal setBackgroundImage: [UIImage imageNamed: @"btn_menu_grey_n.png"] forState: UIControlStateNormal];
                    btnNormal.frame = CGRectMake(20, BUTTONMAGIN*(i+1)+45*i, SCREENSIZE.width-20*2, 45);
                    [btnNormal setTitle: others[i] forState: UIControlStateNormal];
                    btnNormal.titleLabel.font = [UIFont systemFontOfSize: 15];
                    [btnNormal addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                    
                    btnNormal.tag = kNormalButtonTag+i;
                    
                    [actionSheetBottomView addSubview: btnNormal];
                }
            }
        }
        
        // 毁灭性按钮的tag设为-1
        _destructiveButtonIndex = -1;
    }
    
    return self;
}

- (void)show
{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, SCREENSIZE.width, SCREENSIZE.height);
    CGFloat actionSheetHeight = actionSheetTopView.frame.size.height + actionSheetBottomView.frame.size.height;
    actionSheetView.frame = CGRectMake(0, self.frame.size.height - actionSheetHeight, self.frame.size.width, actionSheetHeight);
    [window addSubview: self];
}

- (void)hide
{
    [UIView animateWithDuration: 0.2 animations:^{
        CGRect rect = actionSheetView.frame;
        rect.origin.y += rect.size.height;
        actionSheetView.frame = rect;
        
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

// 按钮点击事件
- (void)buttonAction:(UIButton *)btn
{
    // 点击按钮，提示框消失
    [self hide];
    
    if(btn.tag == kDestroyButtonTag) {
        if([_delegate respondsToSelector: @selector(LRActionSheet:clickedButtonAtIndex:)]) {
            [_delegate LRActionSheet: self clickedButtonAtIndex: _destructiveButtonIndex];
        }
    } else if(btn.tag >= kNormalButtonTag) {
        if([_delegate respondsToSelector: @selector(LRActionSheet:clickedButtonAtIndex:)]) {
            [_delegate LRActionSheet: self clickedButtonAtIndex: btn.tag - kNormalButtonTag];
        }
    }
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index
{
    if(index == _destructiveButtonIndex) {
        if(destroyButtonTitle == nil || [destroyButtonTitle isEqual: @""]) {
            return nil;
        }
        return destroyButtonTitle;
    } else {
        if(index > titlesArray.count) return nil;
        return titlesArray[index];
    }
}

@end
