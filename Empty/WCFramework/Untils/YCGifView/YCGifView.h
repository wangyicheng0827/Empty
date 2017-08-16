//
//  YCGifView.h
//  Empty
//
//  Created by xiaoqi on 2017/8/16.
//  Copyright © 2017年 loveseven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCGifView : UIView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath;
- (id)initWithFrame:(CGRect)frame data:(NSData *)data;
- (id)initWithFrame:(CGRect)frame url:(NSString *)url;

/**
 开始动画
 */
- (void)startGif;

/**
 停止并移除gif动画
 */
- (void)stopGif;

/**
 暂停gif动画
 */
- (void)pauseGif;

/**
 恢复gif动画
 */
- (void)resumeGif;

@end
