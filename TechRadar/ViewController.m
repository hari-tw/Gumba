#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "QuadrantView.h"
#import "CircleView.h"
#import "Radar.h"
#import "AppConstants.h"
#import "RadarItemDetailViewController.h"

@interface ViewController()
@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat newScale;
@end

@implementation ViewController
@synthesize quadrantViews = _quadrantViews;
@synthesize lastScale = _lastScale;
@synthesize newScale = _newScale;

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    for(QuadrantView *quadrantView in self.quadrantViews){
        NSArray *subViews = quadrantView.subviews;
        for(ItemView *subView in subViews){
            if([subView isHidden]){
                [subView setHidden:FALSE];
            }
        }
    }    
}

-(void) searchRadar:(NSString*) searchTerm {
    searchTerm = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    searchTerm = [searchTerm lowercaseString];
    if([searchTerm length] != 0) {
        for(QuadrantView *quadrantView in self.quadrantViews){
            NSArray *subViews = quadrantView.subviews;
            for(ItemView *subView in subViews){
                NSString *blipName = [subView blipName];
                blipName = [blipName lowercaseString];
                if ([blipName rangeOfString:searchTerm].location == NSNotFound) {
                    [subView setHidden:TRUE];
                }
            }
        }}
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchRadar:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchRadar:searchBar.text];
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer  {
    const CGFloat kMaxScale = 2.0;
    const CGFloat kMinScale = 1.0;
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        self.lastScale = [recognizer scale];
    }
    
    if ([recognizer state] == UIGestureRecognizerStateBegan ||
        [recognizer state] == UIGestureRecognizerStateChanged) {
        
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        self.newScale = 1 -  (self.lastScale - [recognizer scale]);
        self.newScale = MIN(self.newScale, kMaxScale / currentScale);
        self.newScale = MAX(self.newScale, kMinScale / currentScale);        
        self.lastScale = [recognizer scale];
    }
    
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        QuadrantView *quadrantView = (QuadrantView *)recognizer.view;
        [quadrantView resize];
    }
}

-(IBAction) displayItemDetails:(UIGestureRecognizer*)sender {
    ItemView *itemView = (ItemView *)sender.view;
    RadarItemDetailViewController *controller = [[RadarItemDetailViewController alloc]init];
    controller.delegate=self;
    controller.detailText = [NSString stringWithFormat:@"%@",itemView.blipName];
    controller.imageText = itemView.type;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.modalPresentationStyle= UIModalPresentationFormSheet;
    [self presentModalViewController:controller animated:YES];
    controller.view.superview.frame = CGRectMake(0, 0, 320, 200);
    controller.view.superview.center = self.view.center;
}

-(void) bindQuadrantTwoFingerPinch :(QuadrantView*)quadrantView {
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)] ;
    [quadrantView addGestureRecognizer:twoFingerPinch];
}

-(void) bindItemTap: (QuadrantView*)quadrantView {
    NSArray *subViews = quadrantView.subviews;
    for(CircleView *subView in subViews){        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayItemDetails:)];
        [singleTap setNumberOfTapsRequired:1];
        [subView setUserInteractionEnabled:YES];
        [subView addGestureRecognizer:singleTap];        
    }
}

-(QuadrantView*) quadrantOriginX:(CGFloat)x Y:(CGFloat)y Quadrant:(Quadrant*)quadrant{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGPoint origin = CGPointMake(x, y);
    CGRect frame = CGRectMake(origin.x, origin.y, screenWidth/2, ((screenHeight-Y_OFFSET-self.navigationController.navigationBar.frame.size.height)/2));
    
    CGFloat centerX = (x > 0.0 ? 0.0 : screenWidth/2);
    CGFloat centerY = (y > Y_OFFSET ? 0.0 : ((screenHeight-Y_OFFSET-self.navigationController.navigationBar.frame.size.height)/2));
    
    QuadrantView *quadrantView = [[QuadrantView alloc]initWithFrame:frame
                                                         WithCenter:CGPointMake(centerX,centerY)
                                                        AndQuadrant:quadrant];
    [quadrantView addCircleViews];
    [quadrantView addTriangleViews];
    [self bindQuadrantTwoFingerPinch:quadrantView];
    [self bindItemTap:quadrantView];
    
    [_quadrantViews addObject:quadrantView];
    return quadrantView;
}

-(void) addQuadrants {
    Radar *radar = [Radar radarFromFile:@"radar"];
    NSMutableArray *allQuadrants = [radar quadrants];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat midPointX = screenWidth/2;
    CGFloat midPointY = ((screenHeight-Y_OFFSET-self.navigationController.navigationBar.frame.size.height)/2)+Y_OFFSET;
    
    [self.view insertSubview:[self quadrantOriginX:0.0 Y:Y_OFFSET Quadrant:[allQuadrants objectAtIndex:0]] atIndex:1];
    [self.view insertSubview:[self quadrantOriginX:midPointX Y:Y_OFFSET Quadrant:[allQuadrants objectAtIndex:1]] atIndex:1];
    [self.view insertSubview:[self quadrantOriginX:0.0 Y:midPointY Quadrant:[allQuadrants objectAtIndex:2]] atIndex:1];
    [self.view insertSubview:[self quadrantOriginX:midPointX Y:midPointY Quadrant:[allQuadrants objectAtIndex:3]] atIndex:1];
} 

-(void) radarItemViewController:(RadarItemDetailViewController*)sender{
    [self dismissModalViewControllerAnimated:YES];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setClipsToBounds:YES];
    _quadrantViews = [[NSMutableArray alloc] init];
    [self addQuadrants];
    [self.view setBackgroundColor:[AppConstants backgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
@end