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
#import <ReactiveCocoa.h>
#import "SingleValueTableViewCell.h"
#import "ChartCell.h"

@interface ResultsViewController () <UITableViewDataSource>

@property NSDictionary *results;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
	// Do any additional setup after loading the view.
    [RACObserve(self, results) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
         if (connectionError)
         {
             NSLog(@"Error: %@", connectionError);
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error connecting to server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertView show];
         }
         else if (data.length > 0)
         {
             NSError *error;
             NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:&error];
             if (error)
             {
                 NSLog(@"Error: %@", error);
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not interpret results." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertView show];
             }
             else
             {
                 self.results = results;
                 NSLog(@"%@", results);
             }
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No data returned." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertView show];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            SingleValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleValueCell"];
            NSArray *array = self.results[@"cumulative_annual_savings"];
            cell.labelText = @"Cumulative Savings";
            NSNumber *value = [array objectAtIndex:[array count] - 1];
            cell.valueText = [NSString stringWithFormat:@"$%d", value.integerValue];
            return cell;
        }
        case 1:
        {
            SingleValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleValueCell"];
            cell.labelText = @"Annual Savings:";
            cell.valueText = @"";
            return cell;
        }
        case 2:
        {
            ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartCell"];
            cell.results = self.results;
            return cell;
        }
        case 3:
        {
            SingleValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleValueCell"];
            NSNumber *value = self.results[@"payback_year"];
            if ([self.results[@"payback_year"] isKindOfClass:[NSString class]] && [self.results[@"payback_year"] isEqualToString:@"Infinity"])
            {
                cell.valueText = @"> 30 years";
            }
            else
            {
                NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
                formatter.maximumFractionDigits = 0;
                [formatter stringFromNumber:value];
                
                cell.valueText =  [NSString stringWithFormat:@"%@ yrs", [formatter stringFromNumber:value]];
            }
            cell.labelText = @"Break Even";
            return cell;
        }
        case 4:
        {
            SingleValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleValueCell"];
            NSNumber *value = self.results[@"estimated_installation_cost"];
            cell.labelText = @"Estimated Cost";
            cell.valueText = [NSString stringWithFormat:@"$%@", value.stringValue];
            return cell;
        }
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.results)
    {
        return 5;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.results ? 1 : 0;
}

# pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        return 300;
    }
    else
    {
        return 72;
    }
}

@end
