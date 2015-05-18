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
@property (nonatomic, strong) CLLocationManager *locationManager;
@property MKPointAnnotation *divvyStop;
@property NSArray *divvyStops;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //getting user location -- not working--
    self.locationManager = [CLLocationManager new];
    [self.locationManager setDelegate:self];

    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    NSLog(@"%@", self.locationManager);

//    [self geocoderLocation:self.address];
//    NSLog(@"%@", self.address);


    NSLog(@"Latitude: %f, Longitude: %f", self.latitude, self.longitude);
    NSLog(@"%@", self.name);
    self.divvyStop = [MKPointAnnotation new];
    self.divvyStop.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.divvyStop.title = self.name;
    [self.mapView addAnnotation:self.divvyStop];

    //self.mapView.delegate = self;
}

//-(void)geocoderLocation:(NSString *)addressString{//updated this to take in a locaiton
//    NSString *address = addressString;
//    CLGeocoder *geocoder = [CLGeocoder new];
//    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
//        for (CLPlacemark *place in placemarks) {
//
//            //now making a pin for the place we serached for
//            MKPointAnnotation *annotation = [MKPointAnnotation new];
//            annotation.coordinate = place.location.coordinate;//taking a pin(annotation and getting the location from the for loop in the placemarks array)
//            annotation.title = place.name;//setting the annotation to the place in place array
//            [self.mapView addAnnotation:annotation];//add it to the map
//        }
//    }];
//}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error   {
    NSLog(@"%@", error);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 1000 && location.verticalAccuracy < 1000) {
            NSLog(@"Found user Location");
            [self.locationManager stopUpdatingLocation];

            //[self reverseGeocode:location];

            break;
        }
    }
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


    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:self.divvyStop.coordinate addressDictionary:nil];
    MKMapItem *mappedItem = [[MKMapItem alloc]initWithPlacemark:placemark];
    NSLog(@"%@", mappedItem);

    [self getDirectionsTo:mappedItem];
}
#pragma mark -- directions
-(void)getDirectionsTo:(MKMapItem *)destinationItem {
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destinationItem;
    request.transportType = MKDirectionsTransportTypeAny;
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {

        MKRoute *route = response.routes.firstObject;
        NSMutableString *directionsString = [NSMutableString new];
        int counter = 1;

        for (MKRouteStep *step in route.steps) {
            [directionsString appendFormat:@"%d: %@\n", counter, step.instructions];
            counter++;
        }
        NSLog(@"%@", directionsString);
        UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Directions"
                          message:directionsString
                          delegate:nil
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK", nil];
        [alert show];

    }];
}

#pragma mark -- another way to get pins with the corresponding location using the name passed from last VC
//-(void)findDivvyStops:(CLLocation *)locale {
//    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
//    request.naturalLanguageQuery = self.name;
//    request.region = MKCoordinateRegionMake(locale.coordinate, MKCoordinateSpanMake(1, 1));
//
//    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
//    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//        MKMapItem *mapItem = response.mapItems.firstObject;
//
//        NSLog(@"%@", mapItem.self.name);
//        [self getDirectionsTo:mapItem];
//
//    }];
//}

#pragma mark -- get locations from where user is
//-(void)reverseGeocode:(CLLocation *)location{
//    CLGeocoder *geocoder = [CLGeocoder new];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark = placemarks.firstObject;//looking into that placemarks array for the [0]
//        NSString *address = [NSString stringWithFormat:@"%@ %@\n%@",
//                             placemark.subThoroughfare,
//                             placemark.thoroughfare,
//                             placemark.locality];
//        NSLog(@"%@", address);
//        //[self findDivvyStops:placemark.location];
//    }];
//
//}

//calculating distances
//CLLocationDistance metersAway = [mapItem.placemark.location distanceFromLocation:location];
//float milesDifference = metersAway / 1609.34;



//soritng distances
//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:true];
//NSArray *sortedArray = [temporaryArray sortedArrayUsingDescriptors:@[sortDescriptor]];
//self.divvyStops = [NSArray arrayWithArray:sortedArray];


@end
