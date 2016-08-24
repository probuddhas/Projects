# Image Watermarking using Bisection Technique<br>
Basically a project on Information Hiding. Here we take an image as a carrier image & a secret binary/bitmap image. Our objective is to embed that secret bitmap image into our carrier image such that the sole existence of the secret embedded image can not detected by any intermediate viewer viewing the image.<br><br>
The project contains 2 parts: Embedding part & Extraction part. During Extraction, we extract the secret bitmap image from the watermarked image.<br><br>
For testing the efficiency of the program, we have compared the embedded bitstream before watermarking & also the extracted bitstream from the watermarked image, and we have found both the bitstrems to be completely identical for most of our test .jpg images in "/images".
# Installation
For running the program, we basically need MATLAB or any other such compatible libraries.<br>
Run the "mainCode.m" file. <br>
For testing with different test images, just change the carrier image file name in line 5 of the file. For testing with another bitmap image just change the file name at line 6.
