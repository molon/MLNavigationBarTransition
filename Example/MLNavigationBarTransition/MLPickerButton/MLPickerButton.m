//
//  MLPickerButton.m
//  InventoryTool
//
//  Created by molon on 14-1-22.
//  Copyright (c) 2014年 Molon. All rights reserved.
//

#import "MLPickerButton.h"

#define kBlackOverlayViewAnimateDuration .25f
@interface MLPickerButton()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(strong,nonatomic,readwrite) UIToolbar *inputAccessoryView;
@property(strong,nonatomic,readwrite) UIPickerView *inputView;
@property(nonatomic,strong) UIView *blackOverlayView;
@property(nonatomic,strong) UILabel *pickerTitleLabel;

@end

@implementation MLPickerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    //添加一个点击可成为第一响应者的Target
    [super addTarget:self action:@selector(defaultTarget) forControlEvents:UIControlEventTouchUpInside];
}

//覆盖了，不让用户外部可以添加Target
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    return;
}

#pragma mark - input
- (UIToolbar *)inputAccessoryView
{
    if(!_inputAccessoryView){
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.inputView.frame.size.width, 44)];
        
        NSString *title = @"取消";
        if (self.delegate&&[self.delegate respondsToSelector:@selector(customCancelTitle)]) {
            title = [self.delegate customCancelTitle];
        }
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        
        if (self.dontDisplayDimmingView) {
            toolBar.items = @[spaceItem,right];
        }else{
            toolBar.items = @[left,spaceItem,right];
        }
        
        toolBar.backgroundColor = [UIColor whiteColor];
        _inputAccessoryView = toolBar;
    }
    return _inputAccessoryView;
}

- (UIPickerView *)inputView
{
    if(!_inputView)
    {
        UIPickerView *pickView = [[UIPickerView alloc]init];
        pickView.showsSelectionIndicator = YES;
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.delegate = self;
        pickView.dataSource = self;
        _inputView = pickView;
    }
    return _inputView;
}

#pragma mark - other view
- (UILabel*)pickerTitleLabel
{
    if (!_pickerTitleLabel) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.inputAccessoryView addSubview:label];
        
        _pickerTitleLabel = label;
        
        _pickerTitleLabel.frame = self.inputAccessoryView.bounds;
    }
    return _pickerTitleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pickerTitleLabel.frame = self.inputAccessoryView.bounds;
}

#pragma mark default target
- (void)defaultTarget
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(shouldBecomeFirstResponderWithPickerButton:)]) {
        if (![self.delegate shouldBecomeFirstResponderWithPickerButton:self]) {
            return;
        }
    }
    
    if (!self.pickerDelegate||!self.pickerDataSource) {
        self.inputView.dataSource = self;
        self.inputView.delegate = self;
    }else{
        self.inputView.dataSource = self.pickerDataSource;
        self.inputView.delegate = self.pickerDelegate;
    }
    [self becomeFirstResponder];
}

#pragma mark - setter and getter
- (void)setDataOfSingleComponentPicker:(NSArray *)dataOfSingleComponentPicker
{
    _dataOfSingleComponentPicker = dataOfSingleComponentPicker;
    
    [self.pickerView reloadAllComponents];
}

- (void)setPickerTitle:(NSString *)pickerTitle
{
    _pickerTitle = [pickerTitle copy];
    
    self.pickerTitleLabel.text = pickerTitle;
}

- (UIPickerView*)pickerView
{
    return self.inputView;
}

- (void)setDontDisplayDimmingView:(BOOL)dontDisplayDimmingView
{
    _dontDisplayDimmingView = dontDisplayDimmingView;
    
    self.inputAccessoryView = nil;
}

#pragma mark toolBar event
-(void)cancel
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customClickCancle)]) {
        [self.delegate customClickCancle];
    }else{
        [self resignFirstResponder];
    }
}

- (void)done
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(doneWithPickerButton:)]) {
        [self.delegate doneWithPickerButton:self];
    }
    
    [self resignFirstResponder];
}

#pragma mark - responder and blackOverlayView
- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder
{
    if ([self isFirstResponder]) {
        return YES;
    }
    BOOL result = [super becomeFirstResponder];
    if (result) {
        if (self.blackOverlayView) {
            [self.blackOverlayView removeFromSuperview];
            self.blackOverlayView = nil;
        }
        if (!self.dontDisplayDimmingView) {
            //添加一个蒙版黑色View
            UIWindow* window = [UIApplication sharedApplication].delegate.window;
            UIView *blackView = [[UIView alloc]initWithFrame:window.bounds];
            blackView.backgroundColor = [UIColor blackColor];
            blackView.userInteractionEnabled = YES;
            [window addSubview:self.blackOverlayView = blackView];
            
            //对其添加点击事件
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.numberOfTouchesRequired = 1;
            [tapGesture addTarget:self action:@selector(tapBlackOverlayViewWithTapGesture:)];
            [self.blackOverlayView addGestureRecognizer:tapGesture];
            
            blackView.layer.opacity = 0.09f;
            [UIView animateWithDuration:kBlackOverlayViewAnimateDuration animations:^{
                blackView.layer.opacity = 0.30f;
            }];
        }
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(becomeFirstResponderWithPickerButton:)]) {
            [self.delegate becomeFirstResponderWithPickerButton:self];
        }
        
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result) {
        [self hideBlackOverlayView];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(resignFirstResponderWithPickerButton:)]) {
            [self.delegate resignFirstResponderWithPickerButton:self];
        }
    }
    return result;
}

#pragma mark - tap event
- (void)tapBlackOverlayViewWithTapGesture:(UITapGestureRecognizer*)tapGesture
{
    [self resignFirstResponder];
}


#pragma mark - picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataOfSingleComponentPicker.count;
}

#pragma mark - picker delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataOfSingleComponentPicker[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectWithPickerButton:)]) {
        [self.delegate didSelectWithPickerButton:self];
    }
}

#pragma mark - touchUpInSide
- (void)touchUpInSide
{
    [self defaultTarget];
}

#pragma mark - other
- (void)dealloc
{
    [self hideBlackOverlayView];
}

- (void)hideBlackOverlayView
{
    if (self.blackOverlayView) {
        UIView *blackOverlayView = self.blackOverlayView;
        self.blackOverlayView = nil;
        [UIView animateWithDuration:kBlackOverlayViewAnimateDuration animations:^{
            blackOverlayView.layer.opacity = 0.01f;
        } completion:^(BOOL finished) {
            [blackOverlayView removeFromSuperview];
        }];
    }
}
@end
