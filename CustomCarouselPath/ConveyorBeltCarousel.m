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

@implementation ConveyorBeltCarousel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.panVector = CGPointMake(0, 1);
        self.itemSpacing = 100.f;
        self.rotateFactor = 0.1f;
        self.rollerRadius = 150.f;
    }
    return self;
}

- (struct CATransform3D)transformOfItemAtOffset:(float)offsetFromFocusPoint
{
    CATransform3D transform = CATransform3DIdentity;
    
    // Work out how far from the top middle of the conveyor belt the item should be
    float scaledOffset = self.itemSpacing * offsetFromFocusPoint;
    
    // The y offset is based on the scaledOffset, but if that's near or past the end of the conveyor belt,
    // it needs to be adjusted so it looks like it's rolling round the end
    float yOffset = scaledOffset;
    float zOffset = 0;
    
    // The roller boundary is the mid point of the rollers on the ends of the conveyor belts
    float rollerBoundary = self.bounds.size.height/2 - self.itemSpacing;
    
    if (abs(scaledOffset) > rollerBoundary) {
        // Work out the angle from the middle of the roller to the item: because we're working
        // in radians, it's just the distance around the circumference divided by the radius
        float angle = (abs(scaledOffset) - rollerBoundary)/self.rollerRadius;
        
        // The y distance above the roller boundary is r * sin(angle)
        yOffset = rollerBoundary + self.rollerRadius * sin(angle);
        
        // Sort out negative offsets so they're still negative
        if (offsetFromFocusPoint < 0) {
            yOffset = -yOffset;
        }
        
        // The z distance away from us is r - r * cos(angle); we need the negative of that to move the item away
        // from rather than towards us
        zOffset = self.rollerRadius * (cos(angle) - 1);
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

@end
