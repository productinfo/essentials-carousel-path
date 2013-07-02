//
//  CustomCarousel.h
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

#import <ShinobiEssentials/SEssentialsCarousel.h>

@interface ConveyorBeltCarousel : SEssentialsCarousel

/** The maximum number of items to fit on the front of the conveyor belt (defaults to 5)*/
@property (nonatomic, assign) int maxNumberOfItemsOnFront;

/** The radius of the rollers on the end of the conveyor belt (defaults to 150)*/
@property (nonatomic, assign) float rollerRadius;

/** The rotation applied to the off-center items (defaults to 0.1) */
@property (nonatomic, assign) float rotateFactor;

@end
