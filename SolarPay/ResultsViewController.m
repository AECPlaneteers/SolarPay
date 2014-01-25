//
//  ResultsViewController.m
//  SolarPay
//
//  Created by Matt Bowman on 1/25/14.
//  Copyright (c) 2014 AEC Planeteers. All rights reserved.
//

#import "ResultsViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>

@interface ResultsViewController ()

@property NSDictionary *results;

@end

@implementation ResultsViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchDataFromWebservice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDataFromWebservice
{
    NSString *urlTemplate = @"http://planeteer.herokuapp.com/solarcalculator?system_size=%d&lat=%f&lon=%f";
    NSString *urlString = [NSString stringWithFormat:urlTemplate, self.kilowatts, self.coordinates.latitude, self.coordinates.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSError *error;
             NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:&error];
             if (error)
             {
                 NSLog(@"Error: %@", error);
             }
             else
             {
                 self.results = results;
             }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
     }];}

@end
