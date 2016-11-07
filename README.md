# Final Projection for the course 16623
## Title
Using a smartphone as a 3D scanner, Chen Kong.

## Summary
In this project, I plan to utilize inteset point detection, RANSAC and Tomasi-Kanade factorization algorithms to arm a smartphone with 3D scanning ability. This projection is focusing on 3D reconstruction problem, more specifically Structure from Motion.

## Background
My porject will take advantage of Accelerate Framework, BRIEF and armadillo to speed up the application.
As mentioned in the class, the power issue is a big concern when developing mobile application.
Our project involves an expensive interest point detection and solving a medium-scale linear system, which can benefit from the packages medtioned above.

## The Challenge
Classical 3D reconstruction methods, e.g. bundle adjustment, generally consume huge computation and is not specifically designed for mobile devices.
However, one of 
