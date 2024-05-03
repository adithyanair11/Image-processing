# Image-processing
Using a Basys3 board, Image Processing operations such as Increasing & Decreasing Brightness, Color Inversion and Converting an Image into Grayscale were performed.

First, the image of size 138x138 was fed into a python code, where it was converted from an RGB scale into a bitmap, using the Computer Vision library OpenCV.

This file was then written onto the system, which is then inputted into the Block Memory Generator of Vivado. This is responsible for handling all the input memory of any connected periphery device such as the Basys3.

The entire coding of the various operations to be performed by the Basys3 was done in Vivado, and after the FPGA board was connected to the system, users could choose what operation they want to be perfomed by the Basys3 board using the switches present at the bottom.

The output is shown in real-time on an LCD monitor connected to the Basys3 board via a VGA cable.
