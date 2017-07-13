# AreaPicker
AreaPicker在底部弹出选择视图，可以根据需求选择相应的地理位置。

导入头文件之后，在需要弹出AreaPicker的地方加入大括号内的代码。

- (IBAction)pickerViewShowBtnClickAction:(UIButton *)sender {
    __block UILabel *label = _resultLab;
    AreaPicker *picker = [[AreaPicker alloc] initWithStyle:AreaPickerWithProvinceCityDistrict];
    picker.areaMessageBlock = ^(NSString *provinceName, NSString *cityName, NSString *districtName, NSString *areaDeatail) {
        label.text = areaDeatail;
    };
    [picker showInView:self.view];
}

block里带回的数据分别是省份名称，市几名称，区/县名称和整体名称。其中省、市、县分别用中划线隔开。
