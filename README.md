# Final Projection for the course 16623
## Title
Using a smartphone as a 3D scanner, Chen Kong.

## Summary
In this project, I plan to utilize interest point detection, RANSAC and Tomasi-Kanade factorization algorithms to make a smartphone work as a 3D scanner. This projection is focusing on 3D reconstruction problem, more specifically Structure from Motion.

## Background
My porject will take advantage of Accelerate Framework, BRIEF and armadillo to speed up the application.
As mentioned in the class, the power issue is a big concern when developing mobile application.
Our project involves an expensive interest point detection and solving a medium-scale linear system, which can benefit from the packages medtioned above.

## The Challenge
Classical 3D reconstruction methods, e.g. bundle adjustment, generally consume huge computation to solve a large non-linear system and does not scale well to mobile devices.
However, one of Structure from Motion algorithm, Tomasi-Kanade factorization utilizes SVD decomposition and estimates the 3D shape by solving a linear system instead.
In this project, I will implement the entire pipline including interest point detection and 3D inversion, and further adjust them to fit mobile computing by taking advantage of computational speedups available on iOS device.

## Goals & Deliverables
I plan to use a sequence of images either prepared or captured by device's camera to achieve 3D reconstruction.
I hope to ahieve the same thing but using videos captured by device's camera.

I will prepare a video of the app in action to show the performance of my application.

## Schedule
+ week Nov.7 - Nov.14: Build up the app's GUI
+ week Nov.14 - Nov.21: Implement interest point detection and build up correspondences along images
+ week Nov.21 - Nov.28: Implement 3D inversion
+ week Nov.28 - Dec.11: Evaluate performance, polish application and prepare tech report.
