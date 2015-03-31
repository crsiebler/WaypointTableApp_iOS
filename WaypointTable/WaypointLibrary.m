/**
 * Copyright 2015 Cory Siebler
 * <p/>
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * <p/>
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * <p/>
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author Cory Siebler csiebler@asu.edu
 * @version March 23, 2015
 */

#import "WaypointLibrary.h"

@implementation WaypointLibrary

- (id)init {
    if ((self = [super init])) {
        Waypoint *ny = [[Waypoint alloc] initWithLat:40.7127 lon:-74.0059 name:@"New York" category:@"City"];
        Waypoint *asup = [[Waypoint alloc] initWithLat:33.3056 lon:-111.6788 name:@"ASU-Poly" category:@"School"];
        Waypoint *asut = [[Waypoint alloc] initWithLat:33.4235 lon:-111.9389 name:@"ASU-Tempe" category:@"School"];
        Waypoint *paris = [[Waypoint alloc] initWithLat:45.6587 lon:2.3508 name:@"Paris" category:@"City"];
        Waypoint *moscow = [[Waypoint alloc] initWithLat:55.75 lon:37.6167 name:@"Moscow" category:@"City"];
        
        self.lib = [[NSMutableDictionary alloc] init];
        self.lib[@"New York"] = ny;
        self.lib[@"ASU-Poly"] = asup;
        self.lib[@"ASU-Tempe"] = asut;
        self.lib[@"Paris"] = paris;
        self.lib[@"Moscow"] = moscow;
    }
    
    return self;
}

// This method takes a waypoint object as parameter and adds that object to the library collection.
- (void)addWaypoint:(Waypoint*) waypoint {
    self.lib[waypoint.name] = waypoint;
}

// This method takes a parameter which is the string name of a waypoint. The named waypoint is to be removed from the library.
- (BOOL)removeWaypointNamed: (NSString*) wpName {
    if ([[self.lib allKeys] containsObject:wpName]) {
        [self.lib removeObjectForKey:wpName];
        return TRUE;
    } else {
        return FALSE;
    }
}

// This method takes a parameter which is the string name of a waypoint. The named waypoint object is returned from this method.
- (Waypoint*)getWaypointNamed: (NSString*) wpName {
    return [self.lib objectForKey:wpName];
}

// This method returns an array which contains the names of all waypoints currently stored in the library.
- (NSArray*)getNames {
    return [self.lib allKeys];
}

@end