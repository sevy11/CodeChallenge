//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#import "Station.h"
#import "MapViewController.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSDictionary *object;
@property NSArray *stationBeanList;
@property NSDictionary *beans;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"http://www.divvybikes.com/stations/json/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        self.stationBeanList = self.object[@"stationBeanList"];

        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stationBeanList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //self.stationBeanList = self.object[@"stationBeanList"];
    self.beans = [self.stationBeanList objectAtIndex:indexPath.row];

    cell.textLabel.text = [self.beans objectForKey:@"stAddress1"];
    int theValue = [[self.beans objectForKey:@"availableBikes"] intValue];
    NSString *intString = [NSString stringWithFormat:@"%d",theValue];
    cell.detailTextLabel.text = intString;

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell{

    NSString *name = [self.beans objectForKey:@"stAddress1"];
    float latitude = [[self.beans objectForKey:@"latitude"] floatValue];
    float longitude =[[self.beans objectForKey:@"longitude"] floatValue];

    MapViewController *mvc = segue.destinationViewController;
    mvc.name = name;
    mvc.latitude = latitude;
    mvc.longitude = longitude;

}
@end
//
//2. When the user taps on a divvy station, a map view should be presented showing the divvy bike location in the center of the map. Scale the map to a span of around .05 x .05 for lat and long. (Note: An image for this, named “bikeImage”, has already been added to the project’s Images.xcassets folder)
//3. When the app launches, it should also determine the user’s current location and show this on the map as well. (Note: The NSLocationAlwaysUsageDescription key and value have already been added to the plist.)
//4. When the user taps on the divvy location, the location name should show along with an information button to the right. When this button is tapped, an alert view should display giving the textual directions to the divvy station from your current location.
//5. Allow the user to search for a specific station name by entering text in the UISearchBar. As each character is typed the list of items shown in the tableview should be reduced to only show the stations that contain the string entered in the search bar.
//6. Sort the divvy stations from closest to farthest from their current location. (Hint: if you have two CLLocations, you can use the method distanceFromLocation to find this in meters.)
//Grading Criteria:​The list of criteria below are what the developers will look for when testing your app.
//● Compiles without error
//● Runs without crashing
//● Retrieves JSON Data Successfully
//● Properly showed a list of stations
//● Drops station pin on map when a station is tapped
//● Showed proper image for pin
//● Pin is properly annotated w/ station name and a detailed disclosure icon ● Showed direction in the UIAlertView
//● Retrieves current location using core location
//● Filtered stations based on text entered in search bar
//● Ordered stations from closest to farthest
//● Use the custom divvy station class properly
//● Submitted by deadline


