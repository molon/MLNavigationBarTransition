//
//  MLPickerButton.h
//  InventoryTool
//
//  Created by molon on 14-1-22.
//  Copyright (c) 2014年 Molon. All rights reserved.
//
/**
 *  
 - (void)doneWithPickerButton:(MLPickerButton*)pickerButton
 {
 //获取当前选择行
    NSUInteger currentSelectedRow = [pickerButton.pickerView selectedRowInComponent:0];
 //选择某行
    [pickerButton.pickerView selectRow:0 inComponent:0 animated:YES];
 }
 */

#import <UIKit/UIKit.h>
@class MLPickerButton;

@protocol MLPickerButtonDelegate <NSObject>

- (void)doneWithPickerButton:(MLPickerButton*)pickerButton;

@optional
- (void)didSelectWithPickerButton:(MLPickerButton*)pickerButton;

- (BOOL)shouldBecomeFirstResponderWithPickerButton:(MLPickerButton*)pickerButton;
- (void)resignFirstResponderWithPickerButton:(MLPickerButton*)pickerButton;
- (void)becomeFirstResponderWithPickerButton:(MLPickerButton*)pickerButton;

//自定义取消事件
- (void)customClickCancle;
- (NSString*)customCancelTitle;

@end

@interface MLPickerButton : UIButton

@property (nonatomic,weak) id<MLPickerButtonDelegate> delegate;
@property (nonatomic,copy) NSString *pickerTitle; //toolBar上面的标题

@property (nonatomic, assign) BOOL dontDisplayDimmingView; //不显示黑色遮罩

@property (nonatomic,weak,readonly) UIPickerView *pickerView; //其实就是inputView

//默认只能使用单列picker，需要多列需要设置pickerDelegate和pickerDataSource并自己定制
@property (nonatomic,strong) NSArray *dataOfSingleComponentPicker; //只包含NSString作为项的单列Picker

@property (nonatomic, strong) id userInfo;

//下面俩任何一个不设置则会认为使用Button作为Picker的delegate，同时需要传递单列数组
//若两个都设置，则dataOfSingleComponentPicker会被忽略。
//认为自己维护Picker数据
@property (nonatomic,weak) id<UIPickerViewDelegate> pickerDelegate;
@property (nonatomic,weak) id<UIPickerViewDataSource> pickerDataSource;


- (void)touchUpInSide;

@end
