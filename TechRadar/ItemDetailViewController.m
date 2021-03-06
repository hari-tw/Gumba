#import "ItemDetailViewController.h"
#import "AppConstants.h"
#import <QuartzCore/QuartzCore.h>

@implementation ItemDetailViewController
@synthesize detail,description, descriptionText, detailText,itemType,imageText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissDetails:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)paintRadarItemDetailHeader {
    detail.layer.masksToBounds = NO;
    [self.detail setText:detailText];
    [self.detail setFont:[AppConstants titleTextFont]];
    [self.detail setNumberOfLines:0];
    if([detailText length] > 28){
        [self.detail sizeToFit];
    }
}

- (void)paintRadarItemDescription {
    description.layer.masksToBounds = NO;
    [self.description setText:[@"\n" stringByAppendingString:self.descriptionText]];
    [self.description setFont:[AppConstants labelTextFont]];
    CGRect frame = self.description.frame;
    frame.size.height = [self.description contentSize].height;
    self.description.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[AppConstants backgroundColor]];
    self.title = @"Radar Notes";
    if ([self.imageText isEqualToString:@"triangle"]) {
        [self.itemType setImage:[UIImage imageNamed:@"large-triangle.png"]];
    }
    if ([self.imageText isEqualToString:@"circle"]) {
        [self.itemType setImage:[UIImage imageNamed:@"large-circle.png"]];
    }
    [self paintRadarItemDetailHeader];
    [self paintRadarItemDescription];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
