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

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSDictionary *object;
@property NSArray *stationBeanList;

@property float latitude;
@property float longitude;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.object = [NSDictionary new];
    self.stationBeanList = [NSArray new];

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
    NSDictionary *bean = [self.stationBeanList objectAtIndex:indexPath.row];

    cell.textLabel.text = [bean objectForKey:@"stAddress1"];
    int theValue = [[bean objectForKey:@"availableBikes"] intValue];
    NSString *intString = [NSString stringWithFormat:@"%d",theValue];
    cell.detailTextLabel.text = intString;

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell{

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *bean = [self.stationBeanList objectAtIndex:indexPath.row];//gives every row in the stationBeanList array

    NSLog(@"%@", bean[@"stAddress1"]);

    self.longitude =[[bean objectForKey:@"longitude"] floatValue];
    self.latitude =[[bean objectForKey:@"latitude"] floatValue];
    NSString *address = [bean objectForKey:@"stAddress1"];

    MapViewController *mvc = segue.destinationViewController;
    mvc.name = address;
    mvc.latitude = self.latitude;
    mvc.longitude = self.longitude;
    mvc.address = address;
}

#pragma mark -- SearchField
//- (void)searchBarButtonClicked:(UISearchBar *)searchBar {
//    //[self performSearchWithKeyword];
//     [self.searchBar resignFirstResponder];
//}
//- (void)performSearchWithKeyword:(NSString *)incomingString withCompletion:(void (^)(NSArray *))complete    {
//
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.divvybikes.com/stations/json/",incomingString]];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//
//                               if (!connectionError) {
//                                   NSArray *objects = [[NSJSONSerialization JSONObjectWithData:data
//                                                                                         options:NSJSONReadingAllowFragments
//                                                                                           error:nil] objectForKey:@"results"];
//                                   //NSDictionary *whatever
//                                   //NSArray *dataArray = [Event eventsFromArray:jsonArray];
//                                   //complete(dataArray);
//                               }
//                           }];
//}
//

@end

///-----DONE ------3. When the app launches, it should also determine the user’s current location and show this on the map as well. (Note: The NSLocationAlwaysUsageDescription key and value have already been added to the plist.)
//4. When the user taps on the divvy location, the location name should show along with an information button to the right. When this button is tapped, an alert view should display giving the textual directions to the divvy station from your current location.
//5. Allow the user to search for a specific station name by entering text in the UISearchBar. As each character is typed the list of items shown in the tableview should be reduced to only show the stations that contain the string entered in the search bar.
//6. Sort the divvy stations from closest to farthest from their current location. (Hint: if you have two CLLocations, you can use the method distanceFromLocation to find this in meters.)


//Grading Criteria:​The list of criteria below are what the developers will look for when testing your app.
//● Compiles without error--1st
//● Runs without crashing--1st
//● Retrieves JSON Data Successfully--1st
//● Properly showed a list of stations--1st

//● Drops station pin on map when a station is tapped---------2nd
//● Showed proper image for pin-------2nd
//● Pin is properly annotated w/ station name and a detailed disclosure icon ● Showed direction in the UIAlertView
//● Retrieves current location using core location------------- 2nd
//● Filtered stations based on text entered in search bar
//● Ordered stations from closest to farthest
//● Use the custom divvy station class properly
//● Submitted by deadline-------------1st


