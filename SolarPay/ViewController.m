//
//  ViewController.m
//  SolarPay
//
//  Created by Matt Bowman on 1/25/14.
//  Copyright (c) 2014 AEC Planeteers. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "DataInputViewController.h"

@interface ViewController ()  <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) MKPointAnnotation *annotation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *continueBarButtonItem;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self initializeMap];
    self.continueBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMap
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, METERS_PER_MILE, METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if (self.annotation)
        {
            [self.mapView removeAnnotation:self.annotation];
        }
        
        
        if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
            return;
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot.coordinate = touchMapCoordinate;
        [self.mapView addAnnotation:annot];
        
        self.coordinates = touchMapCoordinate;
        self.annotation = annot;
        self.continueBarButtonItem.enabled = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DataInputViewController class]])
    {
        DataInputViewController *divc = segue.destinationViewController;
        divc.coordinates = self.coordinates;
    }
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue*)segue
{
    [self.mapView removeAnnotation:self.annotation];
    self.annotation = nil;
}

@end
