//
//  DataInputViewController.m
//  SolarPay
//
//  Created by Matt Bowman on 1/25/14.
//  Copyright (c) 2014 AEC Planeteers. All rights reserved.
//

#import "DataInputViewController.h"
#import <ReactiveCocoa.h>


@interface DataInputViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resultsBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *kilowattsTextField;

@end

@implementation DataInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultsBarButtonItem.enabled = NO;
    self.kilowattsTextField.delegate = self;
    
    [[self.kilowattsTextField rac_textSignal] subscribeNext:^(NSString *text) {
        if (text.length > 0)
        {
            self.resultsBarButtonItem.enabled = YES;
        }
        else
        {
            self.resultsBarButtonItem.enabled = NO;
        }
    }];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f", self.coordinates.longitude];
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f", self.coordinates.latitude];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
