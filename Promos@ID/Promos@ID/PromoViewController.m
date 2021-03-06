//
//  FirstViewController.m
//  Promos@ID
//
//  Created by Farandi Kusumo on 1/16/15.
//  Copyright (c) 2015 Farandi Kusumo. All rights reserved.
//

#import "PromoViewController.h"
#import "AppDelegate.h"
@import CoreLocation;

@interface PromoViewController ()

@end

@implementation PromoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Location in Title
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:) name:@"newLocationNotif" object:nil];
    
    // Initiate PageView
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *recommendedPromoTitle = [NSString stringWithFormat:@"Recommended Promo \n%@",self.userLocationString];
    
    self.pageTitles = @[recommendedPromoTitle,@"Featured Promo",@"Ending Promo"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    ContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startWalkthrough:(id)sender {
}



#pragma mark - Page View Controller Data Source



-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentViewController *)viewController).pageIndex;
    
    if ((index == 0)||(index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentViewController*)viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.pageTitles.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

/*
- (ContentViewController *) itemControllerForIndex: (NSUInteger) itemIndex
{
    if (itemIndex < [_pageTitles count])
    {
        ContentViewController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemController"];
        pageItemController.titleLabel = self.pageTitles[itemIndex];
        pageItemController.pageIndex = itemIndex;
        return pageItemController;
    }
    
    return nil;
}
*/
- (ContentViewController *)viewControllerAtIndex:(NSUInteger) index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemController"];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

-(NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.pageTitles count];
}

-(NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - get location from appdelegate

-(void)updatedLocation:(NSNotification*)notif
{
    CLLocation *userLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
    self.userLocationString = [NSString stringWithFormat:@"%.3f,%.3f",userLocation.coordinate.latitude,userLocation.coordinate.longitude];
}
@end
