//
//  AreaPicker.h
//  ShareView
//
//  Created by dxs on 2017/5/3.
//  Copyright © 2017年 dxs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    AreaPickerWithProvinceCity,
    AreaPickerWithProvinceCityDistrict
} AreaPickerStyle;

typedef void(^AreaMessageBlock)(NSString *provinceName, NSString *cityName, NSString *districtName, NSString *areaDeatail);

@interface AreaPicker : UIButton

@property (nonatomic, copy) AreaMessageBlock areaMessageBlock;

- (id)initWithStyle:(AreaPickerStyle)pickerStyle;

//- (void)getLocationWithAreaMessageBlock:(void(^)(NSString *provinceName, NSString *cityName, NSString *districtName, NSString *areaDeatail))block;

- (void)showInView:(UIView *)view;

@end
