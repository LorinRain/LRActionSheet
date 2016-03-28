# LRActionSheet
一款仿照锤子便签样式的代替系统actionSheet的自定义actionSheet
 
![image](https://github.com/LorinRain/LRActionSheet/raw/master/LRActionSheetSample/ScreenShots/LRActionSheet.gif)

Installation
==============
Drag `LRActionSheet` folder to your project, just `#import "LRActionSheet.h"` when usage

Usage
==============
###
    LRActionSheet *actionSheet = [[LRActionSheet alloc] initWithTitle: @"title" destroyButtonTitle: @"destructive Button" otherButtonTitles: nil];
    actionSheet.delegate = self;
    [actionSheet show];

LRActionSheet Delegate
###
    - (void)LRActionSheet:(LRActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index
    {
        // Do Something here
    }