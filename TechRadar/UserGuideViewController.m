#import "UserGuideViewController.h"
#import "AppConstants.h"

@interface UserGuideViewController ()
@end

@implementation UserGuideViewController
@synthesize scrollView,pageControl,pageControlBeingUsed;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[AppConstants detailBackgroundColor]];
    pageControlBeingUsed = NO;

    NSArray *images = [NSArray arrayWithObjects:@"people", @"background", @"About Radar", nil];

    for (int i = 0; i < images.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        NSString *fullpath = [[NSBundle mainBundle] pathForResource:[images objectAtIndex:i] ofType:@"jpg"];

        UIImage *img = [UIImage imageWithContentsOfFile:fullpath];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.image=img;

        [subview addSubview:imgView];
        [self.scrollView addSubview:subview];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, self.scrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed=YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
@end