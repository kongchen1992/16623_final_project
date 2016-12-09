#Estimating 3D Human Pose by A Few Clicks, Chen Kong.

## Application Description
The application associated with this project is developed specifically for iPad pro.
One can check the [YouTube video](https://youtu.be/oikGjG9ExkQ) for learning instructions and view the results from more viewpoints.

## Approach Introduction
Estimating 3D human pose from a single image, as an application of estimating the 3D shape of an object, has received more and more attention in computer vision community.
A common strategy for this task involves two components: (i) key joints detection and (ii) 3D inversion.
Key joints detection deals with the problems of determining the locations of key joints (*e.g.* head, elbows, knees, and *etc*) in a single image.
Once key joints have been established, the inversion problem of recovering the 3D structure from the 2D point projections must be solved, requiring a priori constraints on structure and camera matrix.

Even though the state-of-the-art key joints detection method, Convolutional Pose Machine, using convolutional neural network achieves an almost perfect performance, it consumes a huge amount of computation, memory and power *i.e.* a desktop tower with four high-performance GPUs.
This is problematic for mobile device application where computation, memory and especially power are highly limited.
However, annotating human joints by using a touch screen is trivial for users and no more than a few clicks.
Therefore, in this project, we develop a GUI for users to rapidly annotate human joints manually instead of using deep neural networks.

As for 3D inversion, we learn a shape dictionary beforehand by leveraging the increasing availability of 3D human shapes.
This saves power and computation dramatically as the dictionary can be saved into a file and the 3D inversion problem degenerates from dictionary learning problem to a sparse code estimation task.
We solve this problem by employing the convex relaxation algorithm originally proposed by Zhou *etal*, 3D shape estimation from 2D landmarks: A convex relaxation approach, which can be optimized efficiently by alternating direction method of multipliers.
