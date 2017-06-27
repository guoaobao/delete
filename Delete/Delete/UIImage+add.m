//
//  UIImage+add.m
//  Delete
//
//  Created by gab on 17/6/26.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "UIImage+add.h"

@implementation UIImage (add)
+(void)load
{
    Method imageWithName=class_getClassMethod(self, @selector(imageWithName:));//自定义

    Method imageNameeeeee=class_getClassMethod(self, @selector(imageNamed:));//系统的
    
    
    method_exchangeImplementations(imageWithName, imageNameeeeee);

}
// 不能在分类中重写系统方法imageNamed，因为会把系统的功能给覆盖掉，而且分类中不能调用super.

+(instancetype)imageWithName:(NSString *)name
{
    UIImage *image = [self imageWithName:name];
    
    if (image == nil) {
        NSLog(@"加载空的图片");
    }
    
    return image;

}

@end
