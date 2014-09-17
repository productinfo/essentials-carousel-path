//
//  ViewController.m
//  CustomCarouselPath
//
//  Created by Alison Clarke on 24/06/2013.
//  
//  Copyright 2013 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "ViewController.h"
#import "ConveyorBeltCarousel.h"

@interface ViewController ()

@end

@implementation ViewController {
    int _numberOfItemsInCarousel;
    NSMutableArray *_carouselData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the carousel data
    _numberOfItemsInCarousel = 10;
    [self setupCarouselData];
    
    // Create a conveyor belt carousel
    ConveyorBeltCarousel *carousel = [[ConveyorBeltCarousel alloc] initWithFrame:self.view.bounds];
    carousel.dataSource = self;
    
    // Adjust the focus point so we don't see the bottom part of the conveyor belt
    carousel.focusPointNormalized = CGPointMake(0.5, 0.7);
    // Make the momentum last a bit longer
    carousel.frictionCoefficient = 0.8;
    
    // Add the view
    [self.view addSubview:carousel];
    
    // Pan up to the 4th item
    [carousel panToItemAtIndex:3 animated:YES withDuration:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCarouselData
{
    // Create an array of coloured, bordered views to go in the carousel
    _carouselData = [[NSMutableArray alloc] init];
    
    for (int i=0; i<=_numberOfItemsInCarousel; i++) {
        // Create a view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 0.8, 300)];
        
        // Add a subview, colored depending on its position in the carousel, with a border
        UIView *borderedView = [[UIView alloc] initWithFrame:view.bounds];
        borderedView.backgroundColor = [UIColor colorWithHue:((float)i)/_numberOfItemsInCarousel saturation:1.0 brightness:0.5 alpha:1.0];
        borderedView.layer.borderWidth = 2.f;
        borderedView.layer.borderColor = [UIColor whiteColor].CGColor;
        borderedView.layer.shouldRasterize = YES;
        [view addSubview:borderedView];
        
        // Apply a shadow to the outer view, so it applies to the border as well as the contents
        CAGradientLayer *shadowGradient = [CAGradientLayer layer];
        shadowGradient.startPoint = CGPointMake(0.5, 0);
        shadowGradient.endPoint = CGPointMake(0.5, 1);
        shadowGradient.locations = @[@0, @1];
        shadowGradient.colors = @[(id)[UIColor colorWithWhite:0 alpha:0].CGColor,
                                  (id)[UIColor colorWithWhite:0 alpha:0.9f].CGColor];
        shadowGradient.frame = view.bounds;
        [view.layer addSublayer:shadowGradient];
        
        // Add the view to the carousel data
        [_carouselData addObject:view];
    }
}

#pragma mark - SEssentialsCarouselDataSource methods

-(NSUInteger)numberOfItemsInCarousel:(SEssentialsCarousel *)carousel
{
    return _numberOfItemsInCarousel;
}

-(UIView *)carousel:(SEssentialsCarousel *)carousel itemAtIndex:(NSInteger)index
{
    return _carouselData[index];
}

@end
