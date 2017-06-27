//
//  TestView.h
//  Delete
//
//  Created by gab on 17/6/12.
//  Copyright © 2017年 gab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

@interface TestView : UIView

-(void)print:(NSString *)str, ... NS_REQUIRES_NIL_TERMINATION;//不定参数方法
-(void)showTest;
@end


@interface TestView (add)

@property(nonatomic,strong) NSString *str;

@end
