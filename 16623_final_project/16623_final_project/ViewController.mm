//
//  ViewController.m
//  16623_final_project
//
//  Created by 工作 on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ViewController.h"


using namespace std;

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    // Setup the view
    arma::mat structure;
    double zangle;
    arma::mat W;
    int ianchor;
    vector<NSString*> anchorNameString;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.resultView.hidden = true;
    [self.leftButton setHidden:true];
    [self.rightButton setHidden:true];
    [self.annotateButton setHidden:true];
    [self.computeButton setHidden:true];
    self.anchorName.hidden = true;
    ianchor = -1;
    
    anchorNameString.push_back(@"Lower Back");
    anchorNameString.push_back(@"Left Hip");
    anchorNameString.push_back(@"Left Knee");
    anchorNameString.push_back(@"Left Foot");
    anchorNameString.push_back(@"Right Hip");
    anchorNameString.push_back(@"Right Knee");
    anchorNameString.push_back(@"Right Foot");
    anchorNameString.push_back(@"Neck");
    anchorNameString.push_back(@"Head");
    anchorNameString.push_back(@"Left Shoulder");
    anchorNameString.push_back(@"Left Elbow");
    anchorNameString.push_back(@"Left Hand");
    anchorNameString.push_back(@"Right Shoulder");
    anchorNameString.push_back(@"Right Elbow");
    anchorNameString.push_back(@"Right Hand");
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // Get the specific point that was touched
    CGPoint point = [touch locationInView:self.liveView];
    
    if(ianchor>=0 && ianchor<15){
        W(0, ianchor) = point.x*2;
        W(1, ianchor) = point.y*2;
        
        // show annotated points
        cv::Mat display_im = [self cvMatFromUIImage: self.liveView.image];
        
        const cv::Scalar RED = cv::Scalar(255,0,0); // Set the RED color
        cv::circle(display_im, cv::Point2d(W(0, ianchor), W(1, ianchor)), 5, RED,5);
        
        self.liveView.image = [self UIImageFromCVMat:display_im];
        ianchor++;
        if(ianchor < 15){
            self.anchorName.text = anchorNameString[ianchor];
        }else{
            self.anchorName.hidden = true;
            self.takeButton.hidden = true;
            self.computeButton.hidden = false;
        }
        cout << W << endl;
    }
}

- (IBAction)takeButtonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.liveView.image = chosenImage;
    [self.annotateButton setHidden:false];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)annotateButtonPressed:(id)sender {
    W = arma::zeros<arma::mat>(2, 15);
    ianchor = 0;
    self.anchorName.hidden = false;
    self.anchorName.text = anchorNameString[ianchor];
}

- (IBAction)computeButtonPressed:(id)sender {

    self.resultView.hidden = false;
    self.liveView.hidden = true;
    [self.leftButton setHidden:false];
    [self.rightButton setHidden:false];
    
    W = normalizeS(W);
    
    NSString *str = [[NSBundle mainBundle] pathForResource:@"dictionary" ofType:@"txt"];
    const char *DictName = [str UTF8String]; // Convert to const char *
    arma::mat dictionary; dictionary.load(DictName); // Load the dictionary into memory should be 384X15
    
    // centralize basis
    arma::mat meanDict = arma::sum(dictionary, 1)/dictionary.n_cols;
    for(int i=0; i < dictionary.n_rows; i++){
        for (int j=0; j < dictionary.n_cols; j ++){
            dictionary(i, j) = dictionary(i, j) - meanDict(i, 0);
        }
    }
    
    double lam = 1;
    double beta = arma::datum::inf;
    structure = ssr(W, dictionary, lam, beta);
    
    const cv::Scalar BLUE = cv::Scalar(0,0,255); // Set the BLUE color
    cv::Mat display_im = cv::Mat::ones(750, 1000, CV_8UC3);
    
    zangle = 0;
    vector<cv::Point2d> projectedPts = ProjectPoints3d(structure, zangle);
    cout << projectedPts << endl;
    display_im = DrawPts(display_im, projectedPts, BLUE);
    display_im = DrawLines(display_im, projectedPts, BLUE);
    
    self.resultView.image = [self UIImageFromCVMat:display_im];
    
    self.takeButton.hidden = false;
    self.computeButton.hidden = true;
    self.annotateButton.hidden = true;
}

- (IBAction)leftButtonPressed:(id)sender {
    const cv::Scalar BLUE = cv::Scalar(0,0,255); // Set the BLUE color
    cv::Mat display_im = cv::Mat::ones(750, 1000, CV_8UC3);
    zangle = zangle + 0.1;
    vector<cv::Point2d> projectedPts = ProjectPoints3d(structure, zangle);
    cout << projectedPts << endl;
    display_im = DrawPts(display_im, projectedPts, BLUE);
    display_im = DrawLines(display_im, projectedPts, BLUE);
    
    self.resultView.image = [self UIImageFromCVMat:display_im];
}

- (IBAction)rightButtonPressed:(id)sender {
    const cv::Scalar BLUE = cv::Scalar(0,0,255); // Set the BLUE color
    cv::Mat display_im = cv::Mat::ones(750, 1000, CV_8UC3);
    zangle = zangle - 0.1;
    vector<cv::Point2d> projectedPts = ProjectPoints3d(structure, zangle);
    cout << projectedPts << endl;
    display_im = DrawPts(display_im, projectedPts, BLUE);
    display_im = DrawLines(display_im, projectedPts, BLUE);
    
    self.resultView.image = [self UIImageFromCVMat:display_im];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

vector<cv::Point2d> ProjectPoints3d(arma::mat pts, double zangle){
    arma::mat rot;
    rot << cos(zangle) << 0 << sin(zangle) << arma::endr
    <<               0 << 1 <<           0 << arma::endr
    <<    -sin(zangle) << 0 << cos(zangle) << arma::endr;
    
    pts = rot*pts;
    
    vector<cv::Point2d> projectedPoints = Arma2Points3d(pts);
    
    return projectedPoints;
}

// Function to draw points
cv::Mat DrawPts(cv::Mat &display_im, vector<cv::Point2d> cv_pts, const cv::Scalar pts_clr)
{
    for(int i=0; i<cv_pts.size(); i++) {
        cv::circle(display_im, cv_pts[i], 5, pts_clr,5); // Draw the points
    }
    return display_im; // Return the display image
}

// Function to draw lines on an UIImage
cv::Mat DrawLines(cv::Mat &display_im, vector<cv::Point2d> cv_pts, const cv::Scalar &pts_clr)
{
    arma::mat connect = arma::zeros<arma::mat>(cv_pts.size(), cv_pts.size());
    connect(0, 1) = 1; connect(0, 4) = 1; connect(0, 7) = 1;
    connect(1, 2) = 1;
    connect(2, 3) = 1;
    connect(4, 5) = 1;
    connect(5, 6) = 1;
    connect(7, 8) = 1; connect(7, 9) = 1; connect(7, 12) = 1;
    connect(9, 10) = 1;
    connect(10, 11) = 1;
    connect(12, 13) = 1;
    connect(13, 14) = 1;
    for(int i=0; i<cv_pts.size(); i++) {
        for(int j=i+1; j<cv_pts.size(); j++){
            if(connect(i, j) == 1){
                cv::line(display_im, cv_pts[i], cv_pts[j], pts_clr, 3); // Draw the line
            }
        }
    }
    return display_im; // Return the display image
}

// Quick function to convert Armadillo to OpenCV Points
vector<cv::Point2d> Arma2Points3d(arma::mat pts)
{
    vector<cv::Point2d> cv_pts;
    for(int i=0; i<pts.n_cols; i++) {
        cv_pts.push_back(cv::Point2d(pts(0,i)*100+500, pts(1,i)*100+350)); // Add points
    }
    return cv_pts; // Return the vector of OpenCV points
}

// Member functions for converting from UIImage to cvMat
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

@end
