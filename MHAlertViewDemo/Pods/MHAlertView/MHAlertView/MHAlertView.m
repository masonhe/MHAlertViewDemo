//
//  MHAlertView.m
//  
//
//  Created by mason on 2017/3/1.
//
//

#import "MHAlertView.h"
#import <PureLayout/PureLayout.h>

#pragma mark - Device Information
#define isRetina [UIScreen mainScreen].scale > 1
#define DeviceIsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define MH_SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define MH_SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

@interface MHAlertView()
/** 背景半透明view */
@property (strong, nonatomic) UIView *maskView;
/** 充当视图容器 */
@property (strong, nonatomic) UIView *containerView;
/** 按钮容器view */
@property (strong, nonatomic) UIView *buttonView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
/** 分隔线 */
@property (strong, nonatomic) UIView *separatorLine;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

/** button array */
@property (strong, nonatomic) NSArray *alertActions;
/** style array */
@property (strong, nonatomic) NSArray *alertActionStyles;

/** red color : GRAlertActionStyle ==  GRAlertActionStyleRed 对应的颜色*/
@property (strong, nonatomic) UIColor *redActionBackgroundColor;
@property (strong, nonatomic) UIColor *redActionTitleColor;


/** white color : GRAlertActionStyle ==  GRAlertActionStyleWhite 对应的颜色*/
@property (strong, nonatomic) UIColor *whiteActionBackgroundColor;
@property (strong, nonatomic) UIColor *whiteActionTitleColor;

@end

@implementation MHAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = MH_SCREEN_WIDTH;
        self.height = MH_SCREEN_HEIGHT;
        if (DeviceIsPad) {
            self.width = MH_SCREEN_HEIGHT;
            self.height = MH_SCREEN_WIDTH;
        } else {
            self.width = MH_SCREEN_WIDTH;
            self.height = MH_SCREEN_HEIGHT;
        }
        
        self.titleFont = [UIFont systemFontOfSize:18.f];
        self.messageFont = [UIFont systemFontOfSize:16.f];
        self.titleColor = RGBA(51, 51, 51, 1);
        self.messageColor = RGBA(51, 51, 51, 1);
        
        self.separatorLineColor = RGBA(220, 220, 220, 1);
        
        self.defaultActionBackroundColor = [UIColor whiteColor];
        self.defaultActionTitleColor = RGBA(150, 150, 150, 1);
        
        self.customActionBackgroundColor = [UIColor whiteColor];
        self.customActionTitleColor = RGBA(150, 150, 150, 1);
    
        self.redActionBackgroundColor = RGBA(253, 76, 91, 1);
        self.redActionTitleColor = [UIColor whiteColor];
        
        self.whiteActionBackgroundColor = [UIColor whiteColor];
        self.whiteActionTitleColor = RGBA(150, 150, 150, 1);
    }
    return self;
}

- (void)layoutSubviews
{
    [self setNeedsLayout];
}

+ (MHAlertView *)show:(NSString *)title message:(NSString *)message actions:(NSArray *)actions alertActionStyles:(NSArray *)alertActionStyles didSeletectItemAction:(void (^)(NSInteger index))didSeletectItemAction
{
    MHAlertView *alertView = [[MHAlertView alloc] init];
    alertView.alertActions = actions;
    alertView.alertActionStyles = alertActionStyles;
    if (DeviceIsPad) {
        [alertView setFrame:CGRectMake(0, 0, alertView.width, alertView.height)];
    } else {
        [alertView setFrame:CGRectMake(0, 0, alertView.width, alertView.height)];
    }
    alertView.tag = 10086;
    UIView *rootView =  [UIApplication sharedApplication].keyWindow;
    UIView *subView = [rootView viewWithTag:10086];
    if (subView) {
        [subView removeFromSuperview];
    }
    [rootView addSubview:alertView];
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    
    [alertView setupUI];
    alertView.didSeletectItemAction = didSeletectItemAction;
    [alertView configButtonWithArray:actions styles:alertActionStyles];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = @"fade";
    [rootView.layer addAnimation:transition forKey:nil];
    
    return alertView;
}

- (void)diss
{
    [self removeFromSuperview];
}

- (void)configButtonWithArray:(NSArray *)actions styles:(NSArray *)styles
{
    while (self.buttonView.subviews.count) {
        [self.buttonView.subviews.lastObject removeFromSuperview];
    }
    UIButton *lastBtn;
    NSInteger total = actions.count;
    for (NSInteger i = 0; i < total; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buttonView addSubview:btn];
        if (i == 0) {
            [btn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.buttonView];
        } else {
            [btn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastBtn];
        }
        [btn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.buttonView];
        [btn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.buttonView];
        if (DeviceIsPad) {
            [btn autoSetDimension:ALDimensionWidth toSize:340.f / total];
        } else {
            [btn autoSetDimension:ALDimensionWidth toSize:(340.f * self.width / 375.f)/total];
        }
        btn.tag = 10000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTitle:actions[i] forState:UIControlStateNormal];
        NSString *styleStr = styles[i];
        NSInteger style = [styleStr integerValue];
        switch (style) {
            case MHAlertActionStyleDefault:
            {
                [btn setTitleColor:self.defaultActionTitleColor forState:UIControlStateNormal];
                [btn setBackgroundColor:self.defaultActionBackroundColor];

                break;
            }
            case MHAlertActionStyleRed:
            {
                [btn setTitleColor:self.redActionTitleColor forState:UIControlStateNormal];
                [btn setBackgroundColor:self.redActionBackgroundColor];

                break;
            }
            case MHAlertActionStyleWhite:
            {
                [btn setTitleColor:self.whiteActionTitleColor forState:UIControlStateNormal];
                [btn setBackgroundColor:self.whiteActionBackgroundColor];
                break;
            }
                case MHAlertActionStyleCustom:
            {
                [btn setTitleColor:self.customActionTitleColor forState:UIControlStateNormal];
                [btn setBackgroundColor:self.customActionBackgroundColor];
                break;
            }
            default:
                break;
        }
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        lastBtn = btn;
    }
}

- (void)clickAction:(UIButton *)event {
    [self diss];
    NSInteger index = event.tag - 10000;
    if (self.didSeletectItemAction) {
        self.didSeletectItemAction(index);
    }
}

- (void)setupUI
{
    [self addSubview:self.maskView];
    [self.maskView autoCenterInSuperview];
    [self.maskView autoSetDimensionsToSize:CGSizeMake(self.width, self.height)];

    [self.maskView setUserInteractionEnabled:YES];

    [self addSubview:self.containerView];
    [self.containerView autoCenterInSuperview];
    if (DeviceIsPad) {
        [self.containerView autoSetDimensionsToSize:CGSizeMake(340.f , 150.f)];
    }

    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.containerView withOffset:self.titleLabel.text.length > 0 ? 10.f : 0];
    [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.containerView];
    [self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.containerView];
    
    [self.containerView addSubview:self.messageLabel];
    [self.messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel];
    [self.messageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.containerView];
    [self.messageLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.containerView];

    if (DeviceIsPad) {
        [self.messageLabel autoSetDimensionsToSize:CGSizeMake(340.f , 106.f)];
    } else {
        [self.messageLabel autoSetDimension:ALDimensionWidth toSize:340.f * self.width / 375.f];
        [self.messageLabel autoSetDimension:ALDimensionHeight toSize:106.f * self.width / 375.f relation:NSLayoutRelationGreaterThanOrEqual];
    }
    
    [self.messageLabel addSubview:self.separatorLine];
    [self.separatorLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.messageLabel withOffset:0];
    [self.separatorLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.containerView];
    [self.separatorLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.containerView];
    [self.separatorLine autoSetDimension:ALDimensionHeight toSize:1.f/[UIScreen mainScreen].scale];
    
    [self.containerView addSubview:self.buttonView];
    [self.buttonView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.separatorLine withOffset:0];
    [self.buttonView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.containerView];
    [self.buttonView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.containerView];
    [self.buttonView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.containerView];
    if (DeviceIsPad) {
        [self.buttonView autoSetDimension:ALDimensionHeight toSize:44.f];
    } else {
        [self.buttonView autoSetDimension:ALDimensionHeight toSize:44.f * self.width / 375.f];
    }
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageFont:(UIFont *)messageFont{
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
}

- (void)setMessageColor:(UIColor *)messageColor{
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setDefaultActionTitleColor:(UIColor *)defaultActionTitleColor{
    _defaultActionTitleColor = defaultActionTitleColor;
    [self configButtonWithArray:self.alertActions styles:self.alertActionStyles];
}

- (void)setCustomActionTitleColor:(UIColor *)customActionTitleColor{
    _customActionTitleColor = customActionTitleColor;
    [self configButtonWithArray:self.alertActions styles:self.alertActionStyles];
}

- (void)setDefaultActionBackroundColor:(UIColor *)defaultActionBackroundColor{
    _defaultActionBackroundColor = defaultActionBackroundColor;
    [self configButtonWithArray:self.alertActions styles:self.alertActionStyles];
}

- (void)setCustomActionBackgroundColor:(UIColor *)customActionBackgroundColor{
    _customActionBackgroundColor = customActionBackgroundColor;
    [self configButtonWithArray:self.alertActions styles:self.alertActionStyles];
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        [_maskView setBackgroundColor:RGBA(0, 0, 0, 0.6)];
    }
    return _maskView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [_containerView setBackgroundColor:[UIColor whiteColor]];
        [_containerView.layer setCornerRadius:5.f];
        [_containerView.layer setMasksToBounds:YES];
    }
    return _containerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = self.titleFont;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = self.messageFont;
        _messageLabel.textColor =self.messageColor;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor whiteColor];
    }
    return _messageLabel;
}

- (UIView *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        [_separatorLine setBackgroundColor:self.separatorLineColor];
    }
    return _separatorLine;
}

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
    }
    return _buttonView;
}

@end
