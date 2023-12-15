clc
clear all
close all

%%

im1 = rgb2gray(imread('000002.bmp'));


im2 = rgb2gray(imread('000003.bmp')); load('calib.mat'); [im1,~] = undistortImage(im1,cameraParams); % Correct images for radial- and tangential distortion 
[im2,~] = undistortImage(im2,cameraParams); 
load('Fdata.mat'); 
im3 = cat(2,im1,im2); 
    
    figure()
        imshow(im3);
        hold on; 
        plot(x1(:,1),x1(:,2),'ro'); 
        plot(x2(:,1)+size(im1,2),x2(:,2),'go'); 
        shift = size(im1,2); 
        cmap = lines(5); 
 
k = 1; 
for i = 1:size(x1,1) 
    ptdraw = [x1(i,1), x1(i,2); x2(i,1)+shift, x2(i,2)];
    plot(ptdraw(:,1),ptdraw(:,2),'LineStyle','-','LineWidth',1,'Color',cmap(k,:));
    k = mod(k+1,5); 
    if k == 0 
       k = 1;
    end 
end

F = EstimateFundamentalMatrix(x1', x2');
%%
vgg_gui_F(im1,im2,F');


%%

% Generate random 3D points 
N = 100; 
p = rand([3,N])* 10 - 5;% from near to far 
p(1,:) = p(1,:) + 15;

% Camera position and orientations 
d = 1.0; 
C1 = [0;-d;0]; 
C2 = [0;d;0];

rad1= -10*(pi/180); 
R1 = [cos(rad1) 0 -sin(rad1);0 1 0;sin(rad1) 0 cos(rad1)]*[0 -1 0;0 0 -1;1 0 0]; 
R2 = [cos(-rad1) 0 -sin(-rad1);0 1 0;sin(-rad1) 0 cos(-rad1)]*[0 -1 0;0 0 -1;1 0 0];

t1 = -R1*C1; 
t2 = -R2*C2;
% plot points and camera locations 

figure() 
    h1 = plot3(p(1,:),p(2,:),p(3,:),'g*');
    hold on; 
    cam1 = plotCamera('Location',C1,'Orientation',R1,'Opacity',0,'Color',[1 0 0],'Size',0.4,'Label','Camera1');
    cam2 = plotCamera('Location',C2,'Orientation',R2,'Opacity',0,'Color',[0 1 0],'Size',0.4,'Label','Camera2');
    axis equal 
    xlabel('x:(m)'); 
    ylabel('y:(m)'); 
    zlabel('z:(m)'); 
    title('Triangulation Simulation'); 
    set(gca,'FontName','Arial','FontSize',20);
% Project 3d points into simulated images 

K = [1000 0 640;0 1000 480;0 0 1];

[uv1, in1] = proj(R1,t1, p, K); 
[uv2, in2] = proj(R2,t2, p, K);

in = in1 & in2; 
q1 = uv1(:,in); 
ptrue = p(:,in); 
q2 = uv2(:,in);
Rs=zeros(3,3,2); % 3D array containing both R1 and R2. 

Rs(:,:,1)=R1; 
Rs(:,:,2)=R2; 
Cs = [C1 C2];

% Array with camera coordinates for both views
pest = zeros(4,size(q1,2)); 

for i = 1:size(q1,2) %% here starts your code %triangulate points based on image point correspondences 
    pest(:,i) = triangulate_svd(q1(:,i), q2(:,i), Rs, Cs, K);
end


% visualization 
figure() 
    plot3(ptrue(1,:),ptrue(2,:),ptrue(3,:),'ro','MarkerSize',8);
    hold on; 
    plot3(pest(1,:),pest(2,:),pest(3,:),'g+','MarkerSize',8);
    hold on; 
    xlabel('x:(m)'); 
    ylabel('y:(m)'); 
    zlabel('z:(m)'); 
    title('Triangulation Simulation'); 
    legend('Truth','Reconstruction'); 
    set(gca,'FontName','Arial','FontSize',20);
    grid on;

%%

baseDir = './images/'; % point to the directory where the dinosaur images are stored.

buildingScene = imageDatastore(baseDir); 
numImages = numel(buildingScene.Files);

load(strcat(baseDir,'viff.xy')); 
x = viff(1:end,1:2:72)'; % pull out x coord of all tracks 
y = viff(1:end,2:2:72)'; % pull out y coord of all tracks

%visualization 
num = 0; 
for n = 1:numImages-1 
    im1 = readimage(buildingScene, n); 
    imshow(im1); 
    hold on; 
    id = x(n,:) ~= -1 & y(n,:) ~= -1; 
    % Data source: "Dinosaur" from www.robots.ox.ac.uk/~vgg/data/data-mview.html.
    
    plot(x(n,id),y(n,id),'go'); 
    num = num + sum(id); 
    hold off; 
    pause(0.1); 

end

% load projection matrices 
load(strcat(baseDir,'dino_Ps.mat'));
ptcloud = zeros(4,num); 
k = 1; 

for i = 1:size(x,1)-1 % tracked features 
    id = x(i,:) ~= -1 & y(i,:) ~= -1 & x(i+1,:) ~= -1 & y(i+1,:) ~= -1; 
    q1 = [x(i,id);y(i,id);]; 
    q2 = [x(i+1,id);y(i+1,id);]; 
    P1 = P{i}; 
    P2 = P{i+1}; 
    [K, R1, t1, c1] = decomposeP(P1); 
    [K, R2, t2, c2] = decomposeP(P2); 
    Rs=zeros(3,3,2); % 3D array containing both R1 and R2. 
    Rs(:,:,1)=R1; 
    Rs(:,:,2)=R2; 
    Cs = [c1 c2];
% Array with camera coordinates
    precons = zeros(4,size(q1,2)); 
    
    ones_var = ones(size(q1,2),1)';
    q1_o = [q1;ones_var];
    q2_o = [q2;ones_var];

    for j = 1:size(q1,2) % your code starts 
        precons(:,j) = triangulate_svd(q1_o(:,j), q2_o(:,j), Rs, Cs,K); 
    end

    ptcloud(:,k:k+size(q1,2)-1) = precons; 
    k = k + size(q1,2);
end

figure 
plot3(ptcloud(1,:),ptcloud(2,:),ptcloud(3,:),'k.','MarkerSize',10); 
hold on;
grid on; 
axis equal; 
view(3); 
    for i = 1:size(x,1) 
        P1 = P{i}; 
        [K, R, t, c] = decomposeP(P1); 
        plotCamera('Location',c,'Orientation',R,'Opacity',0,'Color',[0 1 0],'Size',0.05);
end
