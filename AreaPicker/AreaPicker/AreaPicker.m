//
//  AreaPicker.m
//  ShareView
//
//  Created by dxs on 2017/5/3.
//  Copyright © 2017年 dxs. All rights reserved.
//

#import "AreaPicker.h"

#define kPickerViewHeightScaleToScreen      1/4
#define kPickerViewOriginY                  3/4

@interface AreaPicker ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *provinceArr;
    NSArray *currentCities;
    NSArray *currentDistricts;
}

@property (nonatomic, strong) NSString *locationDetail;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *districtName;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, assign) AreaPickerStyle style;

@end

@implementation AreaPicker

- (id)initWithStyle:(AreaPickerStyle)pickerStyle {
    if (self = [super init]) {
        self.picker = [[UIPickerView alloc] init];
        _style = pickerStyle;
        [_picker setDelegate:self];
        [_picker setDataSource:self];
        [_picker setShowsSelectionIndicator:YES];
        [self addSubview:_picker];
        [self initPickerViewDataWithPlist:@"AreaInfo"];
        [self addTarget:[self viewController] action:@selector(removeFromCurrentShowView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)initPickerViewDataWithPlist:(NSString *)plistName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    provinceArr = [NSArray arrayWithContentsOfFile:plistPath];
    currentCities = [provinceArr[0] valueForKey:@"cities"];
    if (_style == AreaPickerWithProvinceCityDistrict) {
        currentDistricts = [currentCities[0] valueForKey:@"areas"];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_style == AreaPickerWithProvinceCity) {
        return 2;
    } else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return provinceArr.count;
    } else if (component == 1){
        return currentCities.count;
    } else {
        return currentDistricts.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            currentCities = [[provinceArr objectAtIndex:row] objectForKey:@"cities"];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            _provinceName = [[provinceArr objectAtIndex:row] valueForKey:@"province"];
            _cityName = [[currentCities objectAtIndex:0] valueForKey:@"city"];
            if (_style == AreaPickerWithProvinceCityDistrict) {
                currentDistricts = [[currentCities objectAtIndex:0] valueForKey:@"areas"];
                [pickerView reloadComponent:2];
                if (currentDistricts.count > 0) {
                    [pickerView selectRow:0 inComponent:2 animated:YES];
                    _districtName = [currentDistricts objectAtIndex:0];
                }
                _districtName = currentDistricts.count > 0 ? [currentDistricts objectAtIndex:0] : @"";
            }
            [self resetPickerSelectRow];
        }
            break;
        case 1: {
            currentDistricts = [[currentCities objectAtIndex:row] valueForKey:@"areas"];
            _cityName = [[currentCities objectAtIndex:row] valueForKey:@"city"];
            if (_style == AreaPickerWithProvinceCityDistrict) {
                [pickerView reloadComponent:2];
                if (currentDistricts.count > 0) {
                    [pickerView selectRow:0 inComponent:2 animated:YES];
                }
                _districtName = currentDistricts.count > 0 ? [currentDistricts objectAtIndex:0] : @"";
            }
            [self resetPickerSelectRow];
        }
            break;
        case 2: {
            if (currentDistricts.count > 0) {
               _districtName = [currentDistricts objectAtIndex:row];
            } else {
               _districtName = @"";
            }
            [self resetPickerSelectRow];
        }
            break;
            
        default:{
            NSLog(@"something was wrong!");
        }
            break;
    }
}

//返回每一行title
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        return [provinceArr[row] valueForKey:@"province"];
    } else if (1 == component) {
        return [currentCities[row] valueForKey:@"city"];
    } else {
        return currentDistricts[row];
    }
}

-(void)resetPickerSelectRow {
    _locationDetail = [_provinceName stringByAppendingString:[NSString stringWithFormat:@"-%@", _cityName]];
    if (_style == AreaPickerWithProvinceCityDistrict) {
        _locationDetail = (_districtName.length > 0) ? [_locationDetail stringByAppendingString:[NSString stringWithFormat:@"-%@",_districtName]] : _locationDetail;
    }
    __weak AreaPicker *weakself = self;
    weakself.areaMessageBlock(_provinceName, _cityName, _districtName, _locationDetail);
    NSLog(@"provinceName = %@", _provinceName);
    NSLog(@"cityName = %@", _cityName);
    NSLog(@"districtName = %@", _districtName);
    NSLog(@"location = %@", _locationDetail);
}

- (void)showPickerViewInitLocationInfomation {
    _provinceName = [[provinceArr objectAtIndex:0] valueForKey:@"province"];
    _cityName = [[currentCities objectAtIndex:0] valueForKey:@"city"];
    [self resetPickerSelectRow];
}
    
#pragma mark - animation

- (void)showInView:(UIView *)view {
    
    [self showPickerViewInitLocationInfomation];
    
    UIPickerView *picker = nil;
    [self setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [self setBackgroundColor:[UIColor colorWithRed:169.f/255 green:169.f/255 blue:169.f/255 alpha:0.5]];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIPickerView class]]) {
            [subview setFrame:CGRectMake(0, CGRectGetHeight(view.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*kPickerViewHeightScaleToScreen)];
            subview.backgroundColor =[UIColor whiteColor];
            picker = (UIPickerView*)subview;
        }
    }
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        [picker setFrame:CGRectMake(0, CGRectGetHeight(view.frame)*kPickerViewOriginY, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)*kPickerViewHeightScaleToScreen)];
    }];
    
}


//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [UIView animateWithDuration:0.3f animations:^{
//        for (UIView *subview in self.subviews) {
//            if ([subview isKindOfClass:[UIPickerView class]]) {
//                [subview setFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(subview.frame), CGRectGetHeight(subview.frame))];
//            }
//        }
//    }
//                     completion:^(BOOL finished){
//                         self.alpha = 0.f;
//                         [self removeFromSuperview];
//                     }];
//}


//获取当前显示的控制器
- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(UIWindow * tmpWin in windows) {
            
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}


- (void)removeFromCurrentShowView:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[UIPickerView class]]) {
                [subview setFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(subview.frame), CGRectGetHeight(subview.frame))];
            }
        }
    }
                     completion:^(BOOL finished){
                         self.alpha = 0.f;
                         [self removeFromSuperview];
                     }];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
