// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)init {
    self = [super init];
    self.logView.editable = false;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TEST";
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(refreshLog) name:@"refreshLog"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(testComplete) name:@"testComplete"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(refreshHeader:) name:@"refreshHeader"
     object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runTest:(id)sender{
    [self.runButton setEnabled:NO];
    [self.logView setText:@""];
    self.selectedMeasurement = [[NdtTest alloc] init];
    [self.selectedMeasurement run];
}

-(void)refreshLog{
    [self.logView setText:[[self.selectedMeasurement logLines]
                           componentsJoinedByString:@"\n"]];
}

- (void)refreshHeader:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:@"speed"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"Speed %@ %@", [[userInfo objectForKey:@"speed"] objectAtIndex:0], [[userInfo objectForKey:@"speed"] objectAtIndex:1]];
        });
    }
}

-(void)testComplete{
    [self.runButton setEnabled:YES];
    [self.logView setText:[[self.selectedMeasurement logLines]
                           componentsJoinedByString:@"\n"]];
}

@end
