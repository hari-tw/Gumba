#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "QuadrantView.h"
#import "Radar.h"
#import "AppConstants.h"

@implementation ViewController

-(QuadrantView*) quadrantOriginX:(CGFloat)x Y:(CGFloat)y Name:(NSString*)name{
    CGPoint origin = CGPointMake(x, y);
    CGRect frame = CGRectMake(origin.x, origin.y, self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    CGFloat centerX = (x > 0.0 ? 0.0 : self.view.bounds.size.width/2);
    CGFloat centerY = (y > 0.0 ? 0.0 : self.view.bounds.size.height/2);
    return [[QuadrantView alloc]initWithFrame:frame
                                   WithCenter:CGPointMake(centerX,centerY)
                                      AndName:name];
}

-(void) addQuadrants {
    CGFloat midPointX = self.view.bounds.size.width/2;
    CGFloat midPointY = self.view.bounds.size.height/2;

    [self.view insertSubview:[self quadrantOriginX:0.0 Y:0.0 Name:TECHNIQUES] atIndex:1];
    [self.view insertSubview:[self quadrantOriginX:midPointX Y:0.0 Name:TOOLS] atIndex:1];
    [self.view insertSubview:[self quadrantOriginX:0.0 Y:midPointY Name:PLATFORMS] atIndex:1];
    [self.view insertSubview:[self quadrantOriginX:midPointX Y:midPointY Name:LANGUAGES] atIndex:1];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addQuadrants];
    [self.view setBackgroundColor:[AppConstants backgroundColor]];
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] 
                                                initWithTarget:self 
                                                action:@selector(twoFingerPinch:)];
    [[self view] addGestureRecognizer:twoFingerPinch];
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.scale < 1.0) return;
    CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
    self.view.transform = transform;
} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
@end