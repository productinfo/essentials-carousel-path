//
//  CustomCarousel.m
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

#import "ConveyorBeltCarousel.h"

/**
  A carousel which mimics a vertical conveyor belt
 */
@implementation ConveyorBeltCarousel {
    // _rollerBoundary is the distance from the middle of the conveyor belt to the middle of the roller,
    // and is calculated so that the conveyor belt fits exactly in the view
    float _rollerBoundary;
    float _itemSpacing;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Set up some default values
        self.panVector = CGPointMake(0, 1);
        self.maxNumberOfItemsOnFront = 5;
        self.rollerRadius = 150.f;
        self.rotateFactor = 0.1f;
        
        // Calculate the roller boundary and the item spacing
        [self calculateBoundaryAndSpacing];
        
        // Add observers so we can update the boundary and spacing whenever the rollerRadius or
        // maxNumberOfItemsOnFront are changed
        [self addObserver:self forKeyPath:@"rollerRadius" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"maxNumberOfItemsOnFront" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)calculateBoundaryAndSpacing
{
    // Calculate the roller boundary based on the view height and rollerRadius
    _rollerBoundary = self.bounds.size.height/2 - self.rollerRadius;
    // Calculate the item spacing so that maxNumberOfItemsOnFront will fit onto the "flat" part
    // of the conveyor belt
    _itemSpacing = _rollerBoundary * 2/self.maxNumberOfItemsOnFront;
}

- (struct CATransform3D)transformOfItemAtOffset:(float)offsetFromFocusPoint
{
    CATransform3D transform = CATransform3DIdentity;
    
    // Work out how far from the top middle of the conveyor belt the item should be
    float scaledOffset = _itemSpacing * fabsf(offsetFromFocusPoint); 
    
    // The y offset is based on the scaledOffset, but if that's near or past the end of the conveyor belt,
    // it needs to be adjusted so it looks like it's rolling round the end
    float yOffset = scaledOffset;
    float zOffset = 0;
    
    if (scaledOffset > _rollerBoundary + M_PI * self.rollerRadius) {
        // The item is on the "back" of the conveyor belt because its offset is greater
        // than the rollerBoundary plus half the diameter of the roller.
        // The yOffset we need is the half the length of the conveyor belt, minus scaledOffset.
        // The length of the belt is 4 * rollerBoundary plus 2 * pi * rollerRadius
        yOffset = 2 * _rollerBoundary + M_PI * self.rollerRadius - scaledOffset;
        
        // The zOffset is just the diameter of the rollers, negative because it's away from us
        zOffset = -2 * self.rollerRadius;
        
    } else if (scaledOffset > _rollerBoundary) {
        // The item is on the roller of the conveyor belt.
        // Work out the angle from the middle of the roller to the item: because we're working
        // in radians, it's just the distance around the circumference divided by the radius
        float angle = (scaledOffset - _rollerBoundary)/self.rollerRadius;
        
        // The y distance above the roller boundary is r * sin(angle)
        yOffset = _rollerBoundary + self.rollerRadius * sin(angle);
        
        // The z distance away from us is r - r * cos(angle); we need the negative of that to move the item away
        // from rather than towards us
        zOffset = self.rollerRadius * (cos(angle) - 1);
    }
    
    // Sort out negative offsets so they're still negative
    if (offsetFromFocusPoint < 0) {
        yOffset = -yOffset;
    }
    
    // We apply the y translation first
    transform = CATransform3DTranslate(transform, 0, yOffset, 0);
    
    // Next we change the "camera angle" and rotate the items downwards
    transform.m24 = 1/2000.f;
    transform.m34 = -1/500.f;
    transform = CATransform3DRotate(transform, -M_PI_2 * self.rotateFactor, 1, 0, 0);
    
    // Finally we apply the z translation
    transform = CATransform3DTranslate(transform, 0, 0, zOffset);
    return transform;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"rollerRadius"] || [keyPath isEqual:@"maxNumberOfItemsOnFront"]) {
        // If our rollerRadius or maxNumberOfItemsOnFront properties have changed, we need to
        // recalculate the rollerBoundary and itemSpacing, and redraw the carousel.
        [self calculateBoundaryAndSpacing];
        [self redrawCarousel];
    } else {
        // Otherwise we pass the observations up to the parent
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc {
    // Remove the observers
    [self removeObserver:self forKeyPath:@"rollerRadius"];
    [self removeObserver:self forKeyPath:@"maxNumberOfItemsOnFront"];
}

@end
