clear all;
close all;
clc;

I = imread('puppy-gdcfea9a60_640.jpg');
I = rgb2gray(I);

GX = % Fill out GX according to lecture slides (6)
GY = % Fill out GY according to lecture slides (6)
figure, imshow(I);
figure, imshow(imfilter(I,GX));
figure, imshow(imfilter(I,GY));

%% Create Gaussian Kernels

sigma = % Try various integer values of sigma, i.e. 1, 2, 5 an 10 What happens with image and the generated kernel
halfwid = 3*sigma;
[xx,yy] = meshgrid(-halfwid:halfwid, -halfwid:halfwid);
gaussian_kernel = exp(-1/(2*sigma^2) * (xx.^2 + yy.^2));
gaussian_kernel = gaussian_kernel/sum(sum(gaussian_kernel));
figure, imshow(imfilter(I,gaussian_kernel));
