clear all;
close all;
clc;

load cameraPose;
load DJI_Phantom4_cam.mat;
load pointcorrespondences.mat;

R=zeros(3,3,2);
R(:,:,1)=R1;
R(:,:,2)=R2;
Cs = [C1 C2];

points=zeros(length(features1),3);
for j=1:length(features1)
    
[points(j,:)]=triangulate_svd(double([valid_points1(j).Location' valid_points2(j).Location']), R, Cs, K);    
%[points2(j,:)]=triangulate_points_multipleview(double([valid_points1(j).Location' valid_points2(j).Location']), R, Cs,[], K);    


end

points2=points;

writematrix(points,'triangulatedPoints_using_2views.txt');

R=zeros(3,3,3);
R(:,:,1)=R1;
R(:,:,2)=R2;
R(:,:,3)=R3;

Cs = [C1 C2 C3];


points=zeros(length(features1),3);
for j=1:length(features1)
    
points(j,:)=triangulate_svd([double(valid_points1(j).Location') double(valid_points2(j).Location') double(valid_points3(j).Location')], R, Cs, K);    
%points(j,:)=triangulate_points_multipleview([double(valid_points1(j).Location') double(valid_points2(j).Location') double(valid_points3(j).Location')], R, Cs,1, K);    
    
end

writematrix(points,'triangulatedPoints_using_3views.txt');