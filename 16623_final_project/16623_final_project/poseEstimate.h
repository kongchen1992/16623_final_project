//
//  myfit.h
//  Estimate_Homography
//
//  Created by Simon Lucey on 9/21/15.
//  Copyright (c) 2015 CMU_16432. All rights reserved.
//

#ifndef __poseEstimate__
#define __poseEstimate__

#include <stdio.h>
#include "armadillo" // Includes the armadillo library
#include <stdlib.h> // Include the standard library#include "opencv2/features2d/features2d.hpp"
#include "opencv2/nonfree/features2d.hpp"
#include <opencv2/opencv.hpp> // Includes the opencv library

// Functions
arma::mat ssr(arma::mat W, arma::mat B, double lam, double beta);
arma::mat normalizeS(arma::mat S);
double prox_2norm(arma::mat Z, double lam, arma::mat &X);
#endif
