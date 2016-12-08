//
//  ViewController.h
//  16623_final_project
//
//  Created by 工作 on 12/7/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __cplusplus__
#define __cplusplus__

#import <opencv2/opencv.hpp>
#include <stdlib.h> // Include the standard library
#include "poseEstimate.h"
#include "armadillo" // Includes the armadillo library
#endif
@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *liveView;
@property (strong, nonatomic) IBOutlet UIImageView *resultView;
@property (strong, nonatomic) IBOutlet UIButton *takeButton;
@property (strong, nonatomic) IBOutlet UIButton *annotateButton;
@property (strong, nonatomic) IBOutlet UIButton *computeButton;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UILabel *anchorName;
//@property (strong, nonatomic) IBOutlet UIButton *retakeButton;
- (IBAction)takeButtonPressed:(id)sender;
- (IBAction)annotateButtonPressed:(id)sender;
- (IBAction)computeButtonPressed:(id)sender;
- (IBAction)leftButtonPressed:(id)sender;
- (IBAction)rightButtonPressed:(id)sender;
//- (IBAction)retakeButtonPressed:(id)sender;

@end

