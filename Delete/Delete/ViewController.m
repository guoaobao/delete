//
//  ViewController.m
//  Delete
//
//  Created by gab on 17/6/12.
//  Copyright © 2017年 gab. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"

@interface ViewController ()//类的扩展
{

    __weak TestView  *_testView2;

}
@property(nonatomic,strong) TestView *testView1;
@end

@implementation ViewController
@synthesize testNum1=_testNum1;//对属性set,get方法的实现，作用在_testNum1上。

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image=[UIImage imageNamed:@""];

    self->_testNum=8;
    self->_testNum1=6;
    
    TestView  *testView=[[TestView alloc]initWithFrame:CGRectMake(0, 320, 400, 350)];
    testView.backgroundColor=[UIColor blackColor];
    self->_testView2=testView;
    self.testView1=testView;
    
    testView=nil;
    [testView showTest];//(不是野指针)不存在对象调用方法没什么影响，但是存在对象调用的方法不正确就会崩(野指针调用也会崩)。
    testView.str=@"===";//野指针的话就会崩了。。
    [self->_testView2 print:@"1",@"2",@"3", nil];
    [self->_testView2 performSelector:@selector(showTest)];
    self->_testView2.str=@"hahah";
    NSLog(@"====%@",_testView2.str);
    [self test];


    
//    [self.view addSubview:_testView1];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 320, 150, 150)];
    imageView.image=[self filter:[UIImage imageNamed:@"test.jpg"]];
    [self.view addSubview:imageView];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(150, 320, 150, 150)];
    imageView1.backgroundColor=[UIColor redColor];
    imageView1.image=[self clipImgeWithSize:[UIImage imageNamed:@"test.jpg"]];
    [self.view addSubview:imageView1];
    
    
    
    
//    //利用图层绘图
//   //CAShapeLayer(作为遮罩)和贝塞尔曲线(uikit框架)画圆。。。

//    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
//    gradientLayer.frame=self.testView1.bounds;
//    gradientLayer.colors=@[(__bridge id)[UIColor blackColor].CGColor,(id)[UIColor yellowColor].CGColor,(id)[UIColor blueColor].CGColor];
//    gradientLayer.locations=@[@(0.2),@(0.5),@(1.0)];
//    gradientLayer.startPoint=CGPointMake(0, 0);
//    gradientLayer.endPoint=CGPointMake(1, 1);
//    [self.testView1.layer  addSublayer:gradientLayer];
    
   
    
    
    //不规则
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.view.bounds.size);//创建上下文
    CGContextRef gc = UIGraphicsGetCurrentContext();//获取画布
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = CGRectMake(10, 100, 300, 200);
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [self drawLinearGradient:gc path:path startColor:[UIColor greenColor].CGColor endColor:[UIColor redColor].CGColor];//线性渐变
    
    //绘制渐变
//    [self drawRadialGradient:gc path:path startColor:[UIColor greenColor].CGColor endColor:[UIColor redColor].CGColor];//圆圈
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(UIImage *)clipImgeWithSize:(UIImage * )image
{
    CGSize size=[image size];
    CGFloat max= size.width<size.height?size.height:size.width;
    CGFloat min= size.width>size.height?size.height:size.width;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(min, min), NO, 0);//画布的大小影响展示图片的范围
/*    //1.uikit
    [image drawAtPoint:CGPointMake(0, -(max-min)/2)];//直接对上下文渲染，坐标是相对于画布来说的
*/
    
    //2.coregraphics
    CGContextRef ref=UIGraphicsGetCurrentContext();
    
    CGImageRef  cgImage=[image CGImage];
    CGSize cgSize=CGSizeMake(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
    CGImageRef imgeRef=CGImageCreateWithImageInRect(cgImage,CGRectMake(0, 0, cgSize.width, cgSize.height));//生成CGImageRef，这里的大小用cgImage最好
    CGContextDrawImage(ref, CGRectMake(0, -(max-min)/2, size.width, size.height), flip(imgeRef));//直接用imgeRef会发现图片旋转了，所以在第一次CGContextDrawImage方法再旋转一次就正了。。这里的大小用原始图片的大小。。
    
    
//    //uikit方式解决图片倒置。。。
//    UIImage *temImage=[UIImage imageWithCGImage:imgeRef scale:[image scale] orientation:UIImageOrientationUp];
//    [temImage drawInRect:CGRectMake(0, -(max-min)/2, size.width, size.height)];
    
    
    
    
    
    UIImage *newImge=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImge;
    
}


CGImageRef flip (CGImageRef im) {
    //再调一次旋转方向。。
    //coreGraphics框架
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    
    UIGraphicsEndImageContext();
    
    return result; 
    
}

-(UIImage *)filter:(UIImage *)image
{

    CIImage *ciimage=[[CIImage alloc]initWithCGImage:image.CGImage];//生成ciimage
    
    CIFilter *grad=[CIFilter filterWithName:@"CIRadialGradient"];//生成滤镜
    CIVector *vector=[CIVector vectorWithX:image.size.width/2 Y:image.size.height/2];//设置滤镜加在图片上的位置
    [grad setValue:vector forKey:@"inputCenter"];//给滤镜设置属性
    
    
    CIFilter *dark=[CIFilter filterWithName:@"CIDarkenBlendMode" keysAndValues:@"inputImage",grad.outputImage,@"inputBackgroundImage",ciimage, nil];//合并滤镜链
    
    CIContext *context=[CIContext context];
    
    CGImageRef imgeref=[context createCGImage:dark.outputImage fromRect:ciimage.extent];
    
    
    return [UIImage imageWithCGImage:imgeref scale:image.scale orientation:image.imageOrientation];

}





-(void)test{

    NSLog(@"%p,%p,%d",self->_testView2,self.testView1,_testNum);


}
- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
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
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
