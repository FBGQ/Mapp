clc
clear all
close all

%%

fx = 1000;      % pixels
fy = fx;

px = 300;       % pixels
py = 200;

K = zeros(3,3);
K = [fx, 0, px;
    0, fy, py;
    0, 0 ,1];       % intrinsic matrix

beta = deg2rad(90);

Ry = RyRotation(beta);

Ctilde = [-5, 0, 3.5]';
R = Ry;

X = Box3D_v2;

%%
figure, plot3(X(1,:),X(2,:),X(3,:),'.');
hold on
cam1 = plotCamera('Location',Ctilde,'Orientation',R,...
'Opacity',0.0,'Color',[1 0 0],'Size',0.5,'Label','Camera', 'AxesVisible',1);
hold off
axis equal;
axis([-6 6 -1 1 -1 5]);
xlabel('x');
ylabel('y');
zlabel('z');

%%

% Save the entire workspace to a MAT-file
%save('fullWorkspace.mat');

% Load the MAT-file containing the entire workspace
load('fullWorkspace.mat');



%%

K = cameraParams.IntrinsicMatrix';
radial = cameraParams.RadialDistortion;
tangential = cameraParams.TangentialDistortion;

% Step 1: Load the image with radial distortion
distortedImage = imread('image_with_radial_distortion.bmp');

% Step 2: Create a white image with the same size
whiteImage = 255 * ones(size(distortedImage), 'uint8'); % Assuming the image is uint8

% Step 3: Display the white image
figure;
subplot(1, 2, 1), imshow(distortedImage), title('Original Image with Radial Distortion');
subplot(1, 2, 2), imshow(whiteImage), title('White Image');


%%

% Get the size of the image
[height, width, ~] = size(distortedImage);

% Initialize an array to store normalized coordinates
normalized_coords = zeros(height, width, 1);
norm_px_coord = [];
und_coords_temp = [];
image_und = zeros(height, width, 1);

a1 = radial(1);
a2 = radial(2);
a3 = radial(3);

p1 = tangential(1);
p2 = tangential(2);

for u = 1:(size(distortedImage, 1))
    for v = 1:(size(distortedImage, 2))
        norm_px_coord = inv(K)*[v; u; 1];

        x = norm_px_coord(1);
        y = norm_px_coord(2);
        r_sq = (x^2 + y^2);

        xd = x * (1 + a1*r_sq + a2*r_sq^2 + a3*r_sq^3) +  (2*p1*x*y + p2*(r_sq + 2*x*x));
        yd = y * (1 + a1*r_sq + a2*r_sq^2 + a3*r_sq^3) + (2*p2*x*y + p1*(r_sq + 2*y*y));

        und_coords_temp = K * [xd;yd;1];
        
        
        % Round to the nearest integer for proper indexing
        u_rounded = round(und_coords_temp(1));
        v_rounded = round(und_coords_temp(2));

        image_und(u,v) = distortedImage(v_rounded, u_rounded);
        
    end
end

figure()
    imagesc(image_und);
    colormap(gray);
    colorbar; % Optional
    title('Grayscale Image');


%% Part 3 - P3P

load p3p.mat

[R_1_test, t_1_test] = p3p_algorithm(K, ImagePoints_View1, WorldPoints);
[R_2_test, t_2_test] = p3p_algorithm(K, ImagePoints_View2, WorldPoints);
[R_3_test, t_3_test] = p3p_algorithm(K, ImagePoints_View3, WorldPoints);



%% 
function Rx = RxRotation(gamma)
    Rx = [1, 0, 0;
    0, cos(gamma), sin(gamma);
    0, -sin(gamma), cos(gamma)];
end

function Ry = RyRotation(beta)
    Ry = [cos(beta), 0, -sin(beta);
    0, 1, 0;
    sin(beta), 0, cos(beta)];
end

function Rz = RzRotation(alpha)
    Rz = [cos(alpha), sin(alpha), 0;
    -sin(alpha), cos(alpha), 0;
    0,0,1];
end