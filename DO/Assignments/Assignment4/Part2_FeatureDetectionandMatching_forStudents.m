clear all;
close all;
clc;

format long;

FeatureType  = 'SURF'; % 
SURFthreshold = 1200; % 1000 is default, lower threshold gives more features (but less robust)

% import camera parameters
load DJI_Phantom4_cam.mat

% Read filenames on images
img_files = {'100_0002_0067.JPG','100_0002_0068.JPG','100_0002_0100.JPG'};

% Load images, convert to grayscale and remove tangential and radial
% distortion

I1 = imread(img_files{1}); I1=rgb2gray(I1);
I1 = undistortImage(I1,cameraParams);

I2 = imread(img_files{2}); I2=rgb2gray(I2);
I2 = undistortImage(I2,cameraParams);

I3 = imread(img_files{3}); I3=rgb2gray(I3);
I3 = undistortImage(I3,cameraParams);

% Detect SURF features in all images

featureImg1 = detectSURFFeatures(I1,'MetricThreshold',SURFthreshold)
featureImg2 = detectSURFFeatures(I2,'MetricThreshold',SURFthreshold)
featureImg3 = detectSURFFeatures(I3,'MetricThreshold',SURFthreshold)

% Extract Feature Descriptors for all Features

[features1, valid_points1] = extractFeatures(I1, featureImg1);
[features2, valid_points2] = extractFeatures(I2, featureImg2);
[features3, valid_points3] = extractFeatures(I3, featureImg3);

% Match Features between Image 1 and 2 based on Similarity (L2-norm)
% between keypoint descriptors

indexPairs_12 = matchFeatures(features1,features2);%,'Unique',true);

valid_points1 = valid_points1(indexPairs_12(:,1),:);
valid_points2 = valid_points2(indexPairs_12(:,2),:);
features1 = features1(indexPairs_12(:,1),:);
features2 = features2(indexPairs_12(:,2),:);

% Show matched features (before Outlier Rejection(

figure, ax=axes;
showMatchedFeatures(I1,I2,valid_points1(1:100),valid_points2(1:100),'montage','Parent',ax);
title(ax, 'Candidate point matches before RANSAC');
legend(ax, 'Matched points 1','Matched points 2');

% Estimate Fundamental Matrix with RANSAC

RANSACiter = 10;               % Number of Iteration for the RANSAC routine
F=zeros(3,3,RANSACiter);        % Array for Fundamental Matrices
numInliers=zeros(1,RANSACiter); % Vector to show the number of inliers associated with each RANSAC iteration
L=length(features1);
threshold = 0.01;               % Consensus threshold
best_idx=[];                    % vector of indices for feature inliers

for i = 1:RANSACiter
    
    % Randomly select 8 matched points
    sampleFeatures = randperm(length(features1),8);
    
    % Provide your own code for Estimation of the Fundamental Matrix (from
    % Assignment 3)
    F(:,:,i) = EstimateFundamentalMatrix(valid_points1(sampleFeatures).Location',valid_points2(sampleFeatures).Location');
    
    % Compute the consensus
    residual = diag(abs([valid_points2(1:L).Location ones(L,1)]*F(:,:,i)*[valid_points1(1:L).Location ones(L,1)]'));
    
    %find number of points that are within the inlier threshold
    idx = (residual < threshold);
    numInlier=length(residual(idx));
    if (numInlier > max(numInliers))
        best_idx=idx;
    end
    numInliers(i)=numInlier;

end

figure,plot(numInliers) % Visualize the number of inliers in each iteration

% Update feature points by excluding outliers
valid_points1 = valid_points1(best_idx,:);
valid_points2 = valid_points2(best_idx,:);
features1 = features1(best_idx,:);
features2 = features2(best_idx,:);


% Show the feature matches after Outlier Rejection

figure, ax=axes;
showMatchedFeatures(I1,I2,valid_points1(1:100),valid_points2(1:100),'montage','Parent',ax);
title(ax, 'Candidate point matches after RANSAC');
legend(ax, 'Matched points 1','Matched points 2');

% Repeat Feature matching for image 2 and 3 and also perform ransac on this
% set

save('pointcorrespondences.mat','features1', 'valid_points1','features2',...
    'valid_points2','features3', 'valid_points3');