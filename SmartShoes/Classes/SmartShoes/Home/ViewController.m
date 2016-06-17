//
//  ViewController.m
//  nRF Toolbox
//
//  Created by Aleksander Nowakowski on 12/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "HelpViewController.h"
#import "ScannerViewController.h"

@interface ViewController ()<ASValueTrackingSliderDataSource>
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) UIAlertView *alertView;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) BOOL isConnected;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *dataSlider;
@property (weak, nonatomic) IBOutlet UIButton *fengButton;
@property (strong, nonatomic) CBService *uartService;
@property (strong, nonatomic) CBCharacteristic *rxCharacteristic;
@property (strong, nonatomic) CBCharacteristic *txCharacteristic;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) NSDate *weiduDate;
@property (strong, nonatomic) NSDate *shiduDate;
@property (assign, nonatomic) float weidu;
@property (assign, nonatomic) float shidu;
@property (strong, nonatomic) NSDate *timerDate;

@property (assign, nonatomic) NSInteger value;
@end

@implementation ViewController
@synthesize backgroundImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Adjust the background to fill the phone space
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = NSLocalizedString(@"首页", nil);
    _HR_Service_UUID = [CBUUID UUIDWithString:hrsServiceUUIDString];
    _HR_Measurement_Characteristic_UUID = [CBUUID UUIDWithString:hrsHeartRateCharacteristicUUIDString];
    
    _LED_Service_UUID = [CBUUID UUIDWithString:ledServiceUUIDString];
    _LED_Write_Characteristic_UUID = [CBUUID UUIDWithString:ledWriteCharacteristicUUIDString];
    
    _dataLabel.text = @"";
    _isConnected = NO;
    _dataSlider.hidden = YES;
    _dataSlider.dataSource = self;
    _dataSlider.value = 0;
    _dataSlider.minimumValue = 0;
    _dataSlider.maximumValue = 5;
    [_dataSlider showPopUpViewAnimated:YES];
    
    [_dataSlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
//    if (is4InchesIPhone)
//    {
//        // 4 inches iPhone
//        UIImage *image = [UIImage imageNamed:@"Background4.png"];
//        [backgroundImage setImage:image];
//    }
//    else
//    {
//        // 3.5 inches iPhone
//        UIImage *image = [UIImage imageNamed:@"Background35.png"];
//        [backgroundImage setImage:image];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([[segue identifier] isEqualToString:@"help"]) {
        NSLog(@"correct segue");
        HelpViewController *helpVC = [segue destinationViewController];
        helpVC.helpText = [NSString stringWithFormat:@"智能鞋设备是一款可以显示温湿度，并可通过风扇及加热设备实现鞋内恒温恒湿的一款最新智能鞋！后期版本会加入中医针灸按摩功能，使您足底安康，智行天下！\n\nVersion %@",version];
    }
}

-(void)centralManager:(CBCentralManager *)manager didPeripheralSelected:(CBPeripheral *)peripheral
{
    // We may not use more than one Central Manager instance. Let's just take the one returned from Scanner View Controller
    _bluetoothManager = manager;
    _bluetoothManager.delegate = self;
    
    // The sensor has been selected, connect to it
    _hrPeripheral = peripheral;
    _hrPeripheral.delegate = self;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
    [_bluetoothManager connectPeripheral:_hrPeripheral options:options];
}

#pragma mark - ASValueTrackingSliderDataSource
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    NSInteger radiu = (NSInteger)value;
    
    NSString *str = [NSString stringWithFormat:@"%@%%",@(radiu*20)];
    if (_isConnected) {
        if (_value != radiu) {
            NSString *string = [NSString stringWithFormat:@"%@",@(radiu)];
            NSLog(@"writeString:%@",string);
            [self writeString:string];
            _value = radiu;
        }
    }
    return str;
}

- (void)valueChange:(id)sender {
//    if (_isConnected) {
//        NSInteger radiu = (NSInteger)_dataSlider.value;
//        NSString *string = [NSString stringWithFormat:@"%@",@(radiu)];
//        NSLog(@"writeString:%@",string);
//        [self writeString:string];
//    }
}

- (IBAction)HRSAction:(UIButton *)sender {
    _selectedIndex = sender.tag - 3000;
    if (!_isConnected) {
        ScannerViewController *hrs = [self.storyboard instantiateViewControllerWithIdentifier:@"scanner"];
        hrs.delegate = self;
        hrs.filterUUID = _HR_Service_UUID;
        [self presentViewController:hrs animated:YES completion:nil];
    }
    if (_selectedIndex == 3) {
        _dataLabel.hidden = YES;
        _dataSlider.hidden = NO;
        _dataSlider.value = 1;
        [_dataSlider sendActionsForControlEvents:UIControlEventValueChanged];
    }else{
        _dataLabel.hidden = NO;
        _dataSlider.hidden = YES;
    }
}

- (IBAction)connectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        if (_hrPeripheral != nil){
            [_bluetoothManager cancelPeripheralConnection:_hrPeripheral];
        }
    }else{
        ScannerViewController *hrs = [self.storyboard instantiateViewControllerWithIdentifier:@"scanner"];
        hrs.delegate = self;
        hrs.filterUUID = _HR_Service_UUID;
        [self presentViewController:hrs animated:YES completion:nil];
    }
}

- (void)writeString:(NSString *)string
{
//    NSString *str = [NSString stringWithFormat:@"%x",string.integerValue];
    
    unsigned char command[10] = {0};
    unsigned char *pTmp;
    
    pTmp = command;
    
//    *pTmp = 0x01;
    *pTmp = (uint16_t)string.intValue;
    NSData *data =[NSData dataWithBytes:&command length:1];
    NSLog(@"------------------:%@",data);
    [_hrPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0){
//        [_hrPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
//    }else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0){
//        [_hrPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//    }else{
//        NSLog(@"No write property on TX characteristic, %d.", self.txCharacteristic.properties);
//    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
        [error localizedDescription]);
    }
}

//-(void)updatePlotSpace
//{
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
//    [plotSpace scaleToFitPlots:@[self.linePlot]];
//    plotSpace.allowsUserInteraction = NO;
//    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(plotXMinRange)
//                                                    length:CPTDecimalFromInt(plotXMaxRange)];
//    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(plotYMinRange)
//                                                    length:CPTDecimalFromInt(plotYMaxRange)];
//    
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
//    axisSet.xAxis.majorIntervalLength = CPTDecimalFromInt(plotXInterval);
//}
//
//-(void)addHRValueToGraph:(int)data
//{
//    [hrValues addObject:[NSDecimalNumber numberWithInt:data]];
//    if ([hrValues count] > plotXMaxRange) {
//        plotXMaxRange = plotXMaxRange + plotXMaxRange;
//        plotXInterval = plotXInterval + plotXInterval;
//        [self updatePlotSpace];
//    }
//    [self.graph reloadData];
//}

#pragma mark Central Manager delegate methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        // TODO
    }
    else
    {
        // TODO
        NSLog(@"Bluetooth not ON");
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _isConnected = YES;
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
//        [deviceName setText:peripheral.name];
//        [_connectButton setTitle:@"DISCONNECT" forState:UIControlStateNormal];
//        [hrValues removeAllObjects];
    });
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActiveBackground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Peripheral has connected. Discover required services
    [_hrPeripheral discoverServices:@[_HR_Service_UUID]];
    [_hrPeripheral discoverServices:@[_LED_Service_UUID]];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connecting to the peripheral failed. Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
//        [connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        _hrPeripheral = nil;
        
        [self clearUI];
    });
}

-(void)clearUI{
    _dataLabel.text = @"";
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
    _connectButton.selected = NO;
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
//        [connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        _hrPeripheral = nil;
        
        [self clearUI];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
}

- (CBUUID *) txCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"6e400002-b5a3-f393-e0a9-e50e24dcca9e"];
}

#pragma mark Peripheral delegate methods

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    if (!error) {
        for (CBService *hrService in peripheral.services) {
            NSLog(@"service discovered: %@",hrService.UUID);
            if ([hrService.UUID isEqual:_HR_Service_UUID])
            {
                NSLog(@"HR service found");
                [_hrPeripheral discoverCharacteristics:nil forService:hrService];
//                self.uartService = hrService;
//
//                [_hrPeripheral discoverCharacteristics:@[[ self txCharacteristicUUID]] forService:self.uartService];
            }
            else if ([hrService.UUID isEqual:_LED_Service_UUID])
            {
                NSLog(@"Battery service found");
                [_hrPeripheral discoverCharacteristics:nil forService:hrService];
            }
        }
    } else {
        NSLog(@"error in discovering services on device: %@",_hrPeripheral.name);
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        if ([service.UUID isEqual:_HR_Service_UUID]) {
            for (CBCharacteristic *characteristic in service.characteristics)
            {
                if ([characteristic.UUID isEqual:_HR_Measurement_Characteristic_UUID]) {
                    NSLog(@"HR Measurement characteritsic is found");
                    [_hrPeripheral setNotifyValue:YES forCharacteristic:characteristic ];
                }
                if ([characteristic.UUID isEqual:[self txCharacteristicUUID]])
                {
                    NSLog(@"Found TX characteristic");
                    self.txCharacteristic = characteristic;
                }
//                else if ([characteristic.UUID isEqual:_HR_Location_Characteristic_UUID]) {
//                    NSLog(@"HR Position characteristic is found");
//                    [_hrPeripheral readValueForCharacteristic:characteristic];
//                }
            }
        }
        else if ([service.UUID isEqual:_LED_Service_UUID]) {
            
            for (CBCharacteristic *characteristic in service.characteristics)
            {
                if ([characteristic.UUID isEqual:_LED_Write_Characteristic_UUID]) {
                    NSLog(@"Battery Level characteristic is found");
                    [_hrPeripheral readValueForCharacteristic:characteristic];
                    self.txCharacteristic = characteristic;
                }
            }
        }
    } else {
        NSLog(@"error in discovering characteristic on device: %@",_hrPeripheral.name);
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //1s获取两次数据，10s内温度变换3度弹框一次或10s内湿度变5%提示一次
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!error) {
            NSLog(@"received update from HR: %@, UUID: %@",characteristic.value,characteristic.UUID);
            if ([characteristic.UUID isEqual:_HR_Measurement_Characteristic_UUID]) {
                NSLog(@"HRM value: %@",characteristic.value);
//                [self addHRValueToGraph:[self decodeHRValue:characteristic.value]];
                int bpmValue = [self decodeHRValue:characteristic.value];
                if ((bpmValue & (1 << 0)) == 0){
                    int value1 = bpmValue >> 1;
                    int value2 = value1 / 10 ;
                    int lastV = value1 % 10;
                    if (_selectedIndex == 1) {
                        NSString *vv = [NSString stringWithFormat:@"%@.%@",@(value2),@(lastV)];
                        _dataLabel.text = [NSString stringWithFormat:@"%@℃",vv];
                        if (_weiduDate) {
                            double time = [_weiduDate timeIntervalSinceNow];
                            NSLog(@"timewendu:%@",@(time));
                            if (fabs(time) > 10) {
                                _weidu = vv.floatValue;
                                _weiduDate = [NSDate date];
                            }else{
                                if (vv.floatValue - _weidu > 1) {
                                    [self showAlertView:NSLocalizedString(@"温度过高", nil)];
                                }
                            }
                        }else{
                            _weidu = vv.floatValue;
                            _weiduDate = [NSDate date];
                        }
                        
//                        if (vv.floatValue > 45) {
//                            [self showAlertView:NSLocalizedString(@"温度过高", nil)];
//                        }
                    }
                }else if ((bpmValue & (1 << 0)) == 1){//
                    int value1 = bpmValue >> 1;
                    int value2 = value1 / 10 ;
                    int lastV = value1 % 10;
                    if (_selectedIndex == 2) {
                        NSString *vv = [NSString stringWithFormat:@"%@.%@",@(value2),@(lastV)];
                        _dataLabel.text = [NSString stringWithFormat:@"%@%%",vv];
                        if (_shiduDate) {
                            double time = [_shiduDate timeIntervalSinceNow];
                            NSLog(@"timeshidu:%@",@(time));
                            if (fabs(time) > 10) {
                                _shidu = vv.floatValue;
                                _shiduDate = [NSDate date];
                            }else{
                                if (vv.floatValue - _shidu > 3) {
                                    [self showAlertView:NSLocalizedString(@"湿度过高", nil)];
                                }
                            }
                            NSLog(@"shiduvv:%@",vv);
                        }else{
                            _shidu = vv.floatValue;
                            _shiduDate = [NSDate date];
                        }
//                        
//                        if (vv.floatValue > 100) {
//                            [self showAlertView:NSLocalizedString(@"湿度过高", nil)];
//                        }
                    }
                }
                //                NSLog(@"BPM: %d",bpmValue);
//                [self addHRValueToGraph:bpmValue];
            }
            /*else if ([characteristic.UUID isEqual:HR_Location_Characteristic_UUID]) {
                //                hrLocation.text = [self decodeHRLocation:characteristic.value];
            }
            else if ([characteristic.UUID isEqual:Battery_Level_Characteristic_UUID]) {
                const uint8_t *array = [characteristic.value bytes];
                uint8_t batteryLevel = array[0];
                NSString* text = [[NSString alloc] initWithFormat:@"%d%%", batteryLevel];
                [battery setTitle:text forState:UIControlStateDisabled];
                
                if (battery.tag == 0)
                {
                    // If battery level notifications are available, enable them
                    if (([characteristic properties] & CBCharacteristicPropertyNotify) > 0)
                    {
                        battery.tag = 1; // mark that we have enabled notifications
                        
                        // Enable notification on data characteristic
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                }
            }*/
        }
        else {
            NSLog(@"error in update HRM value");
        }
    });
}

- (void)showAlertView:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_alertView.isVisible) {
            return ;
        }
        if (_timerDate) {
            double time = [_timerDate timeIntervalSinceNow];
            NSLog(@"timeDisMiss:%@",@(time));
            if (fabs(time) <= 6) {
                return ;
            }else{
                _timerDate = nil;
            }
        }
        if (!_alertView) {
            self.alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        }
        [_alertView setMessage:title];
        [_alertView show];
        self.timerDate = [NSDate date];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
}

-(int) decodeHRValue:(NSData *)data
{
    const uint8_t *value = [data bytes];
    int bpmValue = 0;
    if ((value[0] & 0x01) == 0) {
        NSLog(@"8 bit HR Value");
        bpmValue = value[1];
    }
    else {
        NSLog(@"16 bit HR Value");
        bpmValue = CFSwapInt16LittleToHost(*(uint16_t *)(&value[1]));
    }
    NSLog(@"BPM: %d",bpmValue);
    NSLog(@"value[0]: %d,value[1]: %d",value[0],value[1]);
    return bpmValue;
}

@end
