//
//  MHAlertView.h
//  
//
//  Created by mason on 2017/3/1.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHAlertActionStyle) {
    MHAlertActionStyleDefault,
    MHAlertActionStyleRed,
    MHAlertActionStyleWhite,
    MHAlertActionStyleCustom
};

@interface MHAlertView : UIView

/** title font */
@property (strong, nonatomic) UIFont *titleFont;
/** message font */
@property (strong, nonatomic) UIFont *messageFont;

/** title color */
@property (strong, nonatomic) UIColor *titleColor;
/** message color */
@property (strong, nonatomic) UIColor *messageColor;

/** separatorLine color */
@property (strong, nonatomic) UIColor *separatorLineColor;

/** default color : GRAlertActionStyle ==  GRAlertActionStyleDefault 对应的颜色*/
@property (strong, nonatomic) UIColor *defaultActionBackroundColor;
@property (strong, nonatomic) UIColor *defaultActionTitleColor;

/** custom color : GRAlertActionStyle ==  GRAlertActionStyleCustom 对应的颜色*/
@property (strong, nonatomic) UIColor *customActionBackgroundColor;
@property (strong, nonatomic) UIColor *customActionTitleColor;

@property (copy, nonatomic) void(^didSeletectItemAction)(NSInteger index);

/**
  * title : 提示标题
  * message : 提示内容
  * actions : 字符串数组，按钮的名称
  * alertActionStyles ：MHAlertActionStyle的数组， 按钮的风格
 */
+ (MHAlertView *)show:(NSString *)title message:(NSString *)message actions:(NSArray *)actions alertActionStyles:(NSArray *)alertActionStyles didSeletectItemAction:(void (^)(NSInteger index))didSeletectItemAction;


@end
