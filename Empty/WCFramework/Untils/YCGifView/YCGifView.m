//
//  YCGifView.m
//  Empty
//
//  Created by xiaoqi on 2017/8/16.
//  Copyright © 2017年 loveseven. All rights reserved.
//

#import "YCGifView.h"
#import <ImageIO/ImageIO.h>

typedef enum {
    YCGifViewTypeFilePath = 0,
    YCGifViewTypeData,
    YCGifViewTypeUrl
} YCGifViewType;

#define YCGifAnimationKey @"YC_GifAnimation"

@interface YCGifView (){
    YCGifViewType       _type;
    NSString            *_filePath;
    NSData              *_data;
    NSString            *_url;
    CGImageSourceRef    _imageSourceRef;
    CAKeyframeAnimation *_animation;
}
@end

@implementation YCGifView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath{
    self = [super initWithFrame:frame];
    if (self) {
        _type     = YCGifViewTypeFilePath;
        _filePath = filePath;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSData *)data{
    self = [super initWithFrame:frame];
    if (self) {
        _type = YCGifViewTypeData;
        _data = data;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame url:(NSString *)url{
    self = [super initWithFrame:frame];
    if (self) {
        _type = YCGifViewTypeUrl;
        _url = url;
    }
    return self;
}

//开始gif动画
- (void)startGif{
    if (_animation) {
        if ([self.layer animationForKey:YCGifAnimationKey]) {
            self.layer.speed = 1.0;
            self.layer.timeOffset = 0.0;
            self.layer.beginTime = 0.0;
        }
        else {
            [self.layer addAnimation:_animation forKey:YCGifAnimationKey];
        }
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (_type == YCGifViewTypeFilePath) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
                    NSDictionary     *dic = @{(NSString *)kCGImagePropertyGIFLoopCount:@0};
                    NSDictionary     *properties = @{(NSString *)kCGImagePropertyGIFDictionary:dic};
                    _imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)properties);
                }
                else {
                    NSLog(@"gif路径错误");
                    return;
                }
            }
            else if (_type == YCGifViewTypeData) {
                NSDictionary        *dic = @{(NSString *)kCGImagePropertyGIFLoopCount:@0};
                NSDictionary *properties = @{(__bridge_transfer NSString *)kCGImagePropertyGIFDictionary:dic};
                _imageSourceRef          = CGImageSourceCreateWithData((CFDataRef)_data, (CFDictionaryRef)properties);
            }
            else {
                NSError *error = nil;
                NSData *data             = [NSData dataWithContentsOfURL:[NSURL URLWithString:_url] options:NSDataReadingUncached error:&error];
                if (data) {
                    NSDictionary *dic        = @{(NSString *)kCGImagePropertyGIFLoopCount:@0};
                    NSDictionary *properties = @{(__bridge_transfer NSString *)kCGImagePropertyGIFDictionary:dic};
                    _imageSourceRef          = CGImageSourceCreateWithData((CFDataRef)data, (CFDictionaryRef)properties);
                }
                else {
                    NSLog(@"gif加载出错:\n url = [%@] \n error = [%@]",_url,error);
                }
            }
            
            if (_imageSourceRef) {
                size_t imageCount        = CGImageSourceGetCount(_imageSourceRef);
                NSMutableArray *images   = [[NSMutableArray alloc] initWithCapacity:imageCount];
                NSMutableArray *times    = [[NSMutableArray alloc] initWithCapacity:imageCount];
                NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:imageCount];
                CGFloat totalTime = 0;
                
                for (size_t i = 0; i < imageCount; i++) {
                    CGImageRef cgimage = CGImageSourceCreateImageAtIndex(_imageSourceRef, i, NULL);
                    [images addObject:(__bridge id)cgimage];
                    CFRelease(cgimage);
                    
                    NSDictionary *properties    = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(_imageSourceRef, i, NULL);
                    NSDictionary *gifProperties = [properties valueForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
                    NSString *gifDelayTime      = [gifProperties valueForKey:(__bridge NSString*)kCGImagePropertyGIFDelayTime];
                    [times addObject:gifDelayTime];
                    totalTime += [gifDelayTime floatValue];
                }
                CFRelease(_imageSourceRef);
                
                float currentTime = 0;
                for (size_t i = 0; i < times.count; i++) {
                    float keyTime = currentTime / totalTime;
                    [keyTimes addObject:[NSNumber numberWithFloat:keyTime]];
                    currentTime += [[times objectAtIndex:i] floatValue];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
                    [_animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
                    [_animation setValues:images];
                    [_animation setKeyTimes:keyTimes];
                    _animation.duration = totalTime;
                    _animation.removedOnCompletion = NO;
                    _animation.fillMode = kCAFillModeForwards;
                    _animation.repeatCount = HUGE_VALF;
                    [self.layer addAnimation:_animation forKey:YCGifAnimationKey];
                });
            }
            else {
                NSLog(@"未识别的gif图片");
            }
        });
    }
}

//停止并移除gif动画
- (void)stopGif{
    if ([self.layer animationForKey:YCGifAnimationKey]) {
        [self.layer removeAnimationForKey:YCGifAnimationKey];
    }
}

//暂停gif动画
- (void)pauseGif{
    if ([self.layer animationForKey:YCGifAnimationKey]) {
        CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.speed = 0.0;
        self.layer.timeOffset = pausedTime;
    }
}

//恢复gif动画
- (void)resumeGif{
    if ([self.layer animationForKey:YCGifAnimationKey]) {
        CFTimeInterval pausedTime = [self.layer timeOffset];
        self.layer.speed = 1.0;
        self.layer.timeOffset = 0.0;
        self.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.layer.beginTime = timeSincePause;
    }
}

- (void)removeFromSuperview {
    [self stopGif];
    [super removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"释放");
}

@end
