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

#import "ViewController.h"
#import "Waypoint.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *distanceField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *toField;

@property (strong, nonatomic) UIPickerView *namePicker;
@property (strong, nonatomic) UIPickerView *toPicker;

@property (strong, nonatomic) Waypoint *toWaypoint;
@property (strong, nonatomic) Waypoint *fromWaypoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.namePicker = [[UIPickerView alloc] init];
    self.toPicker = [[UIPickerView alloc] init];
    
    self.latitudeField.delegate = self;
    self.longitudeField.delegate = self;
    self.categoryField.delegate = self;
    self.namePicker.delegate = self;
    self.toPicker.delegate = self;
    
    self.namePicker.dataSource = self;
    self.toPicker.dataSource = self;
    
    self.distanceField.userInteractionEnabled = FALSE;
    
    self.latitudeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.longitudeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.nameField.inputView = self.namePicker;
    self.toField.inputView = self.toPicker;

    if (self.waypointIndex > 0) {
        NSArray *values = [self.waypoints getNames];
        [self.namePicker selectRow:self.waypointIndex inComponent:0 animated:NO];
        self.fromWaypoint = [self.waypoints getWaypointNamed:values[self.waypointIndex]];
        
        self.nameField.text = [self.fromWaypoint name];
        self.categoryField.text = [self.fromWaypoint category];
        self.latitudeField.text = [NSString stringWithFormat:@"%.4lf", [self.fromWaypoint lat]];
        self.longitudeField.text = [NSString stringWithFormat:@"%.4lf", [self.fromWaypoint lon]];
        
        [self.namePicker reloadAllComponents];
        [self.toPicker reloadAllComponents];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Waypoint" message:@"Enter the name:" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (IBAction)removeClicked:(id)sender {
    if (self.nameField.text != NULL) {
        [self.waypoints removeWaypointNamed:self.nameField.text];
    }
    
    [self.namePicker reloadAllComponents];
    [self.toPicker reloadAllComponents];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *keys = [self.waypoints getNames];
    Waypoint *waypoint = [self.waypoints getWaypointNamed:keys[row]];
    
    if (pickerView == self.toPicker) {
        [self.toField resignFirstResponder];
        self.toWaypoint = waypoint;
        self.toField.text = keys[row];
        
        if (self.fromWaypoint != NULL) {
            double distance = [waypoint distanceGCTo:[self.fromWaypoint lat] lon:[self.fromWaypoint lon] scale:Statute];
            double bearing  = [waypoint bearingGCInitTo:[self.fromWaypoint lat] lon:[self.fromWaypoint lon]];
            self.distanceField.text = [NSString stringWithFormat:@"%.2lf Miles @ %.2lf°", distance, bearing];
        }
    } else {
        [self.nameField resignFirstResponder];
        self.fromWaypoint = waypoint;
        self.nameField.text = keys[row];
        self.categoryField.text = [waypoint category];
        self.latitudeField.text = [NSString stringWithFormat:@"%.4lf", [waypoint lat]];
        self.longitudeField.text = [NSString stringWithFormat:@"%.4lf", [waypoint lon]];
        
        if (self.toWaypoint != NULL) {
            double distance = [waypoint distanceGCTo:[self.toWaypoint lat] lon:[self.toWaypoint lon] scale:Statute];
            double bearing  = [waypoint bearingGCInitTo:[self.toWaypoint lat] lon:[self.toWaypoint lon]];
            self.distanceField.text = [NSString stringWithFormat:@"%.2lf Miles @ %.2lf°", distance, bearing];
        }
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *keys = [self.waypoints getNames];
    
    NSString *result = @"Unknown";
    
    if (row < keys.count) {
        result = keys[row];
    }
    
    return result;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.waypoints getNames].count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.latitudeField resignFirstResponder];
    [self.longitudeField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.toField resignFirstResponder];
    [self.categoryField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    double latitude = [self.latitudeField.text doubleValue];
    double longitude = [self.longitudeField.text doubleValue];
    
    if ([alertView textFieldAtIndex:0].text.length > 0) {
        Waypoint *waypoint = [[Waypoint alloc] initWithLat:latitude lon:longitude name:[alertView textFieldAtIndex:0].text category:self.categoryField.text];
        
        [self.waypoints addWaypoint:waypoint];
    }
    
    [self.namePicker reloadAllComponents];
    [self.toPicker reloadAllComponents];
}

@end