function [s1,s2,s3] = p3p_sidelengths(ImagPts,WorldPts)
%P3P Summary of this function goes here
% Function to calculate the camera-centre (translation and rot) from the
% p3p algorithm by Gr?nert, 1841 (described by Haralick 1994)
% 
% Input Args:
%   ImagPts: column-vector with 3 calibrated image points (homogeneous coordinates) (3 x 3)
%   WorldPts: Column-vector with 3 corresponding World-PTs (inhomogeneous coordinates) (3,3)
% Output Args:
%   side-lengths: s1,s2,s3
% Daniel Olesen, DTU Space, 2019

% Determine the inter-distance between the world-pts
% Convention for Haralick et. al

a = norm(WorldPts(:,2)-WorldPts(:,3));
b = norm(WorldPts(:,1)-WorldPts(:,3));
c = norm(WorldPts(:,1)-WorldPts(:,2));

%ImagPts = inv(intrinsics)*ImagPts; % use calibrated coordinates

alpha = acos(dot(ImagPts(:,2),ImagPts(:,3))/(norm(ImagPts(:,2))*norm(ImagPts(:,3))));
beta = acos(dot(ImagPts(:,1),ImagPts(:,3))/(norm(ImagPts(:,1))*norm(ImagPts(:,3))));
gamma = acos(dot(ImagPts(:,1),ImagPts(:,2))/(norm(ImagPts(:,1))*norm(ImagPts(:,2))));

% Solution of 4-th order polynomial (Haralick p.334)

A4 = ((((a^2-c^2)/b^2)-1)^2) - 4*(c^2/b^2)*cos(alpha)^2;

A3 = 4*( ((a^2 - c^2)/b^2)*(1-((a^2 - c^2)/b^2))*cos(beta)...
    -  (1-((a^2 + c^2)/b^2))*cos(alpha)*cos(gamma) ...
    + 2*(c^2/b^2)*(cos(alpha)^2)*cos(beta));

A2 = 2*( ((a^2-c^2)/b^2)^2 - 1 + 2*(((a^2-c^2)/b^2)^2)*cos(beta)^2 ...
    + 2*((b^2-c^2)/b^2)*cos(alpha)^2 - 4*((a^2+c^2)/b^2)*cos(alpha)*cos(beta)*cos(gamma) ...
    + 2*((b^2-a^2)/b^2)*cos(gamma)^2 );

A1 = 4*( -((a^2 - c^2)/b^2)*(1+((a^2 - c^2)/b^2))*cos(beta) ...
    + 2*(a^2/b^2)*(cos(gamma)^2)*cos(beta) ...
    - (1-((a^2 + c^2)/b^2))*cos(alpha)*cos(gamma) );

A0 = (1 + ((a^2-c^2)/b^2))^2 - 4*(a^2/b^2)*cos(gamma)^2;

v = roots([A4 A3 A2 A1 A0]);
u = zeros(1,4);
% length of s1
s1 = zeros(length(v),1);
s2 = zeros(length(v),1);
s3 = zeros(length(v),1);


    for i=1:length(v) % solve for u and s1,s2,s3

    u(i) = (-1+((a^2 - c^2)/b^2))*v(i)^2 - 2*((a^2 - c^2)/b^2)*cos(beta)*v(i) ...
        + 1 +((a^2 - c^2)/b^2);
    u(i) = u(i)/(2*(cos(gamma)-v(i)*cos(alpha)));

    s1(i) = sqrt(b^2/(1+v(i)^2 - 2*v(i)*cos(beta)));
    s2(i) = s1(i)*u(i);
    s3(i) = s1(i)*v(i);

    end

end

