//
//  ViewController.m
//  AreaPicker
//
//  Created by dxs on 2017/7/13.
//  Copyright © 2017年 dxs. All rights reserved.
//

#import "ViewController.h"

#import "AreaPicker.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pickerViewShowBtnClickAction:(UIButton *)sender {
    __block UILabel *label = _resultLab;
    AreaPicker *picker = [[AreaPicker alloc] initWithStyle:AreaPickerWithProvinceCityDistrict];
    picker.areaMessageBlock = ^(NSString *provinceName, NSString *cityName, NSString *districtName, NSString *areaDeatail) {
        label.text = areaDeatail;
    };
    [picker showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
