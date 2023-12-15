clc 
clear all
close all

%%

X=zeros(2,44);

X(:,1:11)=[-1:0.2:1; repmat(1,1,11)]; X(:,12:22)=[repmat(1,1,11); -(-1:0.2:1)];

X(:,23:33)=[-(-1:0.2:1); repmat(-1,1,11)]; X(:,34:44) =[repmat(-1,1,11); -1:0.2:1;];

figure()
    plot(X(1,:),X(2,:),'*'); 
    axis([-1.2 1.2 -1.2 1.2]);

phi = deg2rad(30);

R_and_T = [cos(phi), -sin(phi)
           sin(phi), cos(phi)];
t = [3;7];

X_rT = R_and_T * X + t;

figure()
    plot(X_rT(1,:),X_rT(2,:),'*'); 

%% homogenous coords
% It is good, so that we can deal with infinity points
% In inhomogenous coords we have to do the rotation first and then the
% translation
% While in homogen. we can do everything with a single matrix

R = [cos(phi), -sin(phi),;
           sin(phi), cos(phi)];

X_in = [X; ones(1, length(X))];

P = [R, t; ones(1, length(R)), 0];

X_rT_homo = P * X_in;

figure()
    plot(X_rT_homo(1,:),X_rT_homo(2,:),'*'); 



