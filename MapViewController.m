//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "StationsListViewController.h"
#import "Station.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *divvyStop;
@property NSArray *divvyStops;
//@property float latitude;
//@property float longitude;


//@property (readonly, nonatomic) float latitude;
//@property (readonly, nonatomic) float longitude;

//@property NSString *latitude;
//@property NSString *longitude;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.latitude = self.latitude;
//    self.longitude = self.longitude;
//    self.name = self.name;
    NSLog(@"Latitude: %f, Longitude: %f", self.latitude, self.longitude);
    NSLog(@"%@", self.name);
    self.divvyStop = [MKPointAnnotation new];
    self.divvyStop.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.divvyStop.title = self.name;
    [self.mapView addAnnotation:self.divvyStop];

    //getting user location
    //self.locationManager = [CLLocationManager new];
    //[self.locationManager requestWhenInUseAuthorization];
    //[self.locationManager startUpdatingLocation];
    //self.mapView.showsUserLocation = YES;

    //self.locationManager.delegate = self;
    self.mapView.delegate = self;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isEqual:mapView.userLocation]) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pin.canShowCallout = YES;
        pin.image = [UIImage imageNamed:@"bikeImage"];
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return pin;
    } else  {
        return nil;
    }
}

//alert comes up in direction method, which is in pin method
//UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Directions" message:direction method delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
//
////alertView.tag = indexPath.row;
//[alertView show];



//zero in on pin
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{

    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.05;
    coordinateSpan.longitudeDelta = 0.05;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:YES];
}



//getting directions:
//-(void)getDirectionsTo:(MKMapItem *)destinationItem {
//    MKDirectionsRequest *request = [MKDirectionsRequest new];
//    request.source = [MKMapItem mapItemForCurrentLocation];
//    request.destination = destinationItem;
//    request.transportType = MKDirectionsTransportTypeAutomobile;
//    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
//    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//
//        //direction to be printed out somewhere
//        MKRoute *route = response.routes.firstObject;
//        NSMutableString *directionsString = [NSMutableString new];
//        int counter = 1;
//
//        for (MKRouteStep *step in route.steps) {
//            [directionsString appendFormat:@"%d: %@\n", counter, step.instructions];
//            counter++;
//        }
//        //make a textViewField = directionsString;
//        
//    }];
//}

//calculating distances
//CLLocationDistance metersAway = [mapItem.placemark.location distanceFromLocation:location];
//float milesDifference = metersAway / 1609.34;



//soritng distances
//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:true];
//NSArray *sortedArray = [temporaryArray sortedArrayUsingDescriptors:@[sortDescriptor]];
//self.divvyStops = [NSArray arrayWithArray:sortedArray];






@end
