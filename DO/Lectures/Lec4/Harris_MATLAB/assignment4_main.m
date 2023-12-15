clear all;
close all;
clc;

%% Part 1 - Harris Corner detector

k=0.05

% load Image and show it
imColor=imread('./data/library2.jpg');
figure;imshow(imColor);
if size(imColor,3) == 3
    imGray=rgb2gray(imColor);
else
    imGray = imColor;
end

% convert image to double array
im = im2double(imGray);

% Find Spatial derivates

% Use Matlab's inbuilt functions

Ix = edge(im,'sobel',[],'horizontal');
Iy = edge(im,'sobel',[],'vertical');

% Do it on your own

s_x = [1 0 -1; 2 0 -2; 1 0 -1];
s_y = s_x';

% Ix2=imfilter(im,s_x);
% Iy2=imfilter(im,s_y);
Ix2=KernelFiltering(im,s_x);
Iy2=KernelFiltering(im,s_y);
idx=Ix2 < 0.6;
Ix2(idx)=0;
Ix2 = logical(Ix2)

figure,subplot(221),imshow(Ix),
subplot(222),imshow(Iy2),
subplot(223),imshow(Iy),
subplot(224),imshow(Ix2),

Ixx=Ix.*Ix;
Ixy=Ix.*Iy;
Iyy=Iy.*Iy;

% gaussian kernel
g = fspecial ('gaussian', 3, 1);

% smoothing
Ixx = imfilter(Ixx,g,'replicate'); Iyy = imfilter(Iyy ,g,'replicate');
Ixy = imfilter(Ixy,g,'replicate');

figure,subplot(121),imshow(Ix),
subplot(122), imshow(Iy);

figure,subplot(131),imshow(Ixx),
subplot(132), imshow(Iyy);
subplot(133), imshow(Ixy);

% response map
C = Ixx.*Iyy - Ixy.^2 - 0.04.*(Ixx + Iyy).^2;

% thresholding

threshold = 0.3*max(C(:)); 
C(C(:)<threshold) = 0;

figure;
imshow(C);

% nonmaxima suppression
[row , col ] = nonmaxsuppts(C,'radius', 2, 'N', 1000) ;
% plot
figure; 
img = imshow(imColor),title ('my-Harris'); 
hold on
plot (col,row,'ro','MarkerSize',10) ,