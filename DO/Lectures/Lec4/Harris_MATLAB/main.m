clear all;
close all;
clc;

imColor=imread('./data/library2.jpg');
figure;imshow(imColor);
if size(imColor,3) == 3
imGray=rgb2gray(imColor);
else
imGray = imColor;
end
im = im2double(imGray);
% 
Ix = edge(im ,'Sobel' ,[],'horizontal'); 
Iy = edge(im ,'Sobel' ,[],'vertical'); % gradient

figure ; subplot (1 ,2 ,1); imshow(Ix); subplot (1 ,2 ,2); imshow(Iy); % plot

% Ixx , Iyy , Ixy
Ixx = Ix .* Ix; 
Iyy = Iy .* Iy; 
Ixy = Ix .* Iy;

% gaussian kernel
g = fspecial ('gaussian', 3, 1);

% smoothing
Ixx = imfilter(Ixx,g,'replicate'); Iyy = imfilter(Iyy ,g,'replicate');
Ixy = imfilter(Ixy,g,'replicate');

% response map
C = Ixx.*Iyy - Ixy.^2 - 0.04.*(Ixx + Iyy).^2;

% thresholding

threshold = 0.3*max(C(:)); C(C(:)<threshold) = 0;

figure;
imshow(C);

% nonmaxima suppression
[row , col ] = nonmaxsuppts(C,'radius', 2, 'N', 1000) ;
% plot
figure; 
img = imshow(imColor),title ('my-Harris'); 
hold on
plot (col,row,'ro','MarkerSize',10) ,
