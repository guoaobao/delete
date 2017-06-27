//
//  TestView.m
//  Delete
//
//  Created by gab on 17/6/12.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "TestView.h"
static NSString *const key=@"name";

@implementation TestView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ref= UIGraphicsGetCurrentContext();//Cocoa就会为你创建一个图形上下文，此时你对图形上下文的所有绘图操作都会显示在UIView上，直接获取画布
    CGMutablePathRef path = CGPathCreateMutable();
    //绘制Path
    CGRect rect1 = CGRectMake(0, 100, 300, 200);
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect1), CGRectGetMinY(rect1));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect1), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect1), CGRectGetMaxY(rect1));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [self drawRadialGradient:ref path:path startColor:[UIColor greenColor].CGColor endColor:[UIColor redColor].CGColor];//圆圈
    
    CGPathRelease(path);
    
    //////////////////////////////////////////////////////这个地方已经不需要从画布上获取图片展示到view上了，因为画布本身系统创建好添加到view上了，直接在上面画就可以了///////////////////////////////////////////不然还要从画布上获取图片展示//////////////////////


}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);//添加路径。
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);//开始在画布上绘制。
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
-(void)print:(NSString *)str, ...NS_REQUIRES_NIL_TERMINATION
{
    if(str){
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        NSString *resultArg=str;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, str);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)

//        do {
//            NSLog(@"====%@",resultArg);
//            
//        } while ((resultArg=va_arg(args, NSString *)));

        for (NSString *str1= str; str1 != nil; str1 = va_arg(args, NSString*)) {
            
            NSLog(@"%@",str1);
            
        }
        
     
        //结束遍历
        va_end(args);
     }

}




void showTest(id self,SEL sel)
{
    NSLog(@"%@ %@",self,NSStringFromSelector(sel));

}
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    
    if (sel == @selector(showTest)) {
//         动态添加eat方法
//        
//         第一个参数：给哪个类添加方法
//         第二个参数：添加方法的方法编号
//         第三个参数：添加方法的函数实现（函数地址）
//         第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(self, @selector(showTest), showTest, "v@:");
        
    }
    
    return [super resolveInstanceMethod:sel];
}
@end
@implementation TestView (add)
-(NSString *)str
{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));

}
-(void)setStr:(NSString *)str
{

    objc_setAssociatedObject(self, (__bridge const void *)(key), str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end



