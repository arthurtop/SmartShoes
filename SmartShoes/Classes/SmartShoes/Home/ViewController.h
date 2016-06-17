//
//  ViewController.h
//  nRF Toolbox
//
//  Created by Aleksander Nowakowski on 12/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ScannerDelegate.h"
#import "CorePlot-CocoaTouch.h"

@interface ViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate,ScannerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (strong, nonatomic) CBUUID *HR_Service_UUID;
@property (strong, nonatomic) CBUUID *HR_Measurement_Characteristic_UUID;
@property (strong, nonatomic) CBUUID *LED_Service_UUID;
@property (strong, nonatomic) CBUUID *LED_Write_Characteristic_UUID;
@property CPTScatterPlot *linePlot;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTGraph *graph;

@property (strong, nonatomic) CBPeripheral *hrPeripheral;
@end
