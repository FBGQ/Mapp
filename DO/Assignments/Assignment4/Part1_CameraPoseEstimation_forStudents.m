clear all;
close all;
clc;

addpath('p3p'); % Folder for p3p implementation (not necessary if you have
                % your p3p function in same folder as this script)

% Load Camera Intrinsics and Distortion parameters

load DJI_Phantom4_cam.mat

% Read RTK GNSS positions from Drone (as reference)
cam_pos=readtable('camera_positions.txt');

% Estimate Position and orientation of fisrt camera view (Image 67)

Img_Idx=67; % Image index 67

% Control points in world Coordinates (UTM Zone 32 - Easting Northing Up)
    X67 = [719970.70 6191955.16 69.59;
           719939.94 6191966.88 69.27;
           719978.34 6191972.15 71.10;
           719943.87 6191988.15 74.42];

% Image points [u,v] in pixel coordinates
       
   x67 = [1622 1321;
          3745 1239;
          1575 2536;
          4143 2659];
      
 % Undistort image points (correct for Radial and Tangential distortion)
   
   ux67 = undistortPoints([x67']',cameraParams);
    
ImagPts = K\[ux67(1,:) 1;ux67(2,:) 1;ux67(3,:) 1; ux67(4,:) 1]';
WorldPts = X67';

% Use your own P3P function below
%--------------------------------

    % Your code begins here
    
        [R1,t1] = % Enter your own P3P implementation here

    % Your code ends here

C1 = -R1'*t1;
C1Rtk = table2array(cam_pos(Img_Idx,[2 3 4]));
fprintf('\n Camera position error (compared to RTK onboard Drone [m]) :%f %f %f \n', C1-C1Rtk');

% Repeat the above calculations for Image 68 (C2) and Image 100 (C3)

% Store the camera positions and rotation in *.mat file for easy import
% later on.

save('cameraPose.mat','R1','C1','R2','C2','R3','C3');
