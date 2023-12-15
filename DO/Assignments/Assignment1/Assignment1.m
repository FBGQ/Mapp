clc
clear 
close all

%% Transform 2D Homogenous coordinates into inhomogeneous representation

a = [3, 4, 1];
b = [4, 6.5, 0.5];
c = [5, 2, 0.1];
d = [10, 100, 20];
e = [0.1, 0.2, 100];

hom_coords = [a;b;c;d;e];

for i = 1:size(hom_coords, 1)
    inhom_coords(i, 1) = hom_coords(i, 1) / hom_coords(i,3);
    inhom_coords(i, 2) = hom_coords(i, 2) / hom_coords(i,3);
end

inhom_coords

%% Transform the following 3D Homogenous coords into inhomogeneous

a = [3, 4, 1, 0.1];
b = [4, 6.5, 0.5, 2];
c = [5, 2, 0.1, 3];
d = [10, 100, 20, 1];
e = [0.1, 0.2, 100, 10];

hom_coords = [a;b;c;d;e];

for i = 1:size(hom_coords, 1)
    inhom_coords(i, 1) = hom_coords(i, 1) / hom_coords(i,4);
    inhom_coords(i, 2) = hom_coords(i, 2) / hom_coords(i,4);
    inhom_coords(i, 3) = hom_coords(i, 3) / hom_coords(i,4);
end

inhom_coords

%% Find the line which passes the following two 2D points (given in inhomo representation)

p1 = [1, 2]';
p2 = [5, 3.5]';

m = (p2(2) - p1(2)) / (p2(1) - p1(1));
k = -m*p1(1) + p1(2);

%% Compute the closest distance from the line found before to the following point

p3 = [7.5, 3.6]';

a = -m;
b = 1;
c = -k;

dist = abs(a*p3(1) + b*p3(2) + c) / (sqrt(a^2 + b^2));

fprintf("Distance")
dist

%% 1.5 Find the intesection of two lines given as 

I1 = [1, 1, -1]';
I2 = [-1, 3, -4]';

p_inter = cross(I1, I2);

%% 2 2D Transformations
x = 0:0.1:5;
y = 0:0.1:5;
pt = [x repmat(x(end), 1, numel(y)) fliplr(x) repmat(x(1), 1, numel(y));
repmat(y(1), 1, ...
numel(y)) y repmat(y(end), 1, numel(y)) fliplr(y)];
pt = [pt;ones(1,size(pt,2))];

% Plot the square
figure()
    plot(pt(1, :), pt(2, :), 'b-');
    axis equal
    % Add labels and title if needed
    xlabel('X-axis');
    grid on
    xlim([-1, 6]);
    ylim([-1,6]);
    ylabel('Y-axis');
    title('Square Plot');



%% 2.1 

A1 = [0.866, 0.5, 2.0;
    -0.5, 0.866, 1.0;
    0, 0, 1.0];

A2 = [0.1732, 0.1, 2.0;
    -0.1, 0.1732, -2.0;
    0, 0, 1.0];

A3 = [0.5, 0.3, 2.0;
    0.1, 1.2, -2.0;
    0, 0, 1.0];

Trans1 = A1 * pt;
Trans2 = A2 * pt;
Trans3 = A3 * pt;


% Create a figure and set it to full screen
fig = figure('Position', get(0, 'Screensize'));

% Create a subplot with 2 rows and 2 columns
subplot(2, 2, 1);
plot(pt(1, :), pt(2, :), 'b-', 'LineWidth', 1.3);
axis equal
grid on
title('Original Square');

subplot(2, 2, 2);
plot(Trans1(1,:), Trans1(2, :), 'r-', 'LineWidth', 1.3);
axis equal
grid on
title('Transformed Square A1');

% Add two additional plots (you can replace these with your own data)
subplot(2, 2, 3);
plot(Trans2(1,:), Trans2(2, :), 'g-', 'LineWidth', 1.3);
axis equal
grid on
title('Transformed Square A2');

subplot(2, 2, 4);
plot(Trans3(1,:), Trans3(2, :), 'm-', 'LineWidth', 1.3);
axis equal
grid on
title('Transformed Square A3');

figure()
    plot(pt(1,:), pt(2,:), 'b-', 'LineWidth', 1.3)
    grid on
    axis equal
    hold on
    plot(Trans1(1,:), Trans1(2,:), 'r-', 'LineWidth', 1.3)
    hold on
    plot(Trans2(1,:), Trans2(2,:), 'g-', 'LineWidth', 1.3)
    hold on
    plot(Trans3(1,:), Trans3(2,:), 'm-', 'LineWidth', 1.3)

%% Inverse Perspective Mapping

I = imread('Tiles_perspective_distort.png');
%I = imread('Two-Points-Perspective-Example-2-No-Extended-Lines.jpg');
I = im2double(I);
%I = rgb2gray(I);
h = figure;
imshow(I);
[x,y] = ginput(4);
q = round([x y]');
q = [q;ones(1,4)];
I = drawlines(I,q,[[1 2];[3 4];[1 4];[2 3]]);
imshow(I);

%%

% m = (q(2,2) - q(2,1)) / (q(1,2) - q(1,1));
% k = -m*q(1,1) + q(2,1);
% 
% a = -m;
% b = 1;
% c = -k;
% 
% l12 = [a, b, c];
% 
% m = (q(2,4) - q(2,3)) / (q(1,4) - q(1,3));
% k = -m*q(1,3) + q(2,3);
% 
% a = -m;
% b = 1;
% c = -k;
% 
% l34 = [a, b, c];
% 
% m = (q(2,4) - q(2,2)) / (q(1,4) - q(1,1));
% k = -m*q(1,1) + q(2,1);
% 
% a = -m;
% b = 1;
% c = -k;
% 
% l14 = [a, b, c];
% 
% m = (q(2,3) - q(2,2)) / (q(1,3) - q(1,2));
% k = -m*q(1,3) + q(2,3);
% 
% a = -m;
% b = 1;
% c = -k;
% 
% l23 = [a, b, c];



l1 = cross(q(:,1), q(:,2));
l2 = cross(q(:,3), q(:,4));
l3 = cross(q(:,1), q(:,4));
l4 = cross(q(:,3), q(:,2));


p1 = cross(l1, l2);
p2 = cross(l3, l4);

val_line = cross(p1,p2);

v_norm = val_line/(val_line(3));

H = [1, 0 , 0;
    0, 1, 0;
    v_norm(1), v_norm(2), v_norm(3)];

I2 = warpping(I, H);

imshow(I2);
