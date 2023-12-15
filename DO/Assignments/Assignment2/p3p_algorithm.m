function [R, t] = p3p_algorithm(K, ImagePoints_View, WorldPoints)
% Francois Goor - s222722 - DTU - 2023
% input:
    % K : 
    % ImagePoints_View : The image points [3 x something], every column should contain the x,y,1 coords
    % WorldPoints : The World points [3 x something], every column should contain x, y, z coordinates
% output: 
    % R : Rotation matrix
    % t : translation vector



% Normalize image coordinates
normalized_coords_view = K \ ImagePoints_View;


% Choose at least three points to estimate the camera position
% For simplicity, let's choose the first three points
ImgPts_Selected = [normalized_coords_view(:, 1), normalized_coords_view(:, 2), normalized_coords_view(:, 3)];
WorldPts_Selected = [WorldPoints(:, 1), WorldPoints(:, 2), WorldPoints(:, 3)];

[s1a,s2a,s3a] = p3p_sidelengths(ImgPts_Selected,WorldPts_Selected);

ImgPts_Selected = [normalized_coords_view(:, 2), normalized_coords_view(:, 3), normalized_coords_view(:, 4)];
WorldPts_Selected = [WorldPoints(:, 2), WorldPoints(:, 3), WorldPoints(:, 4)];

[s2b,s3b,s4b] = p3p_sidelengths(ImgPts_Selected,WorldPts_Selected);

s2a_round = round(s2a, 4);
s2b_round = round(s2b, 4);
s3a_round = round(s3a, 4);
s3b_round = round(s3b, 4);

s2 = intersect(s2a_round, s2b_round);
s3 = intersect(s3a_round, s3b_round);

ImgPts_Selected = [normalized_coords_view(:, 1), normalized_coords_view(:, 2), normalized_coords_view(:, 4)];
WorldPts_Selected = [WorldPoints(:, 1), WorldPoints(:, 2), WorldPoints(:, 4)];

[s1c,s2c,s4c] = p3p_sidelengths(ImgPts_Selected,WorldPts_Selected);

s1a_round = round(s1a, 4);
s1c_round = round(s1c, 4);

s1 = intersect(s1a_round, s1c_round);

% In this case the index is the index 4. Every solution with the "a"
% diciture has the same result. Remember to implement a better solution

ImgPts_Selected = [normalized_coords_view(:, 1), normalized_coords_view(:, 2), normalized_coords_view(:, 3)];
% Form unit vectors from normalized image points
unit_vectors = ImgPts_Selected ./ vecnorm(ImgPts_Selected);

% Scale unit vectors by side lengths to get coordinates in camera
% coordinates, coloumns are points. 
camera_coordinates = [s1 * unit_vectors(:, 1), s2 * unit_vectors(:, 2), s3 * unit_vectors(:, 3)];

XC_centroid = 1 / size(camera_coordinates, 1) * [sum(camera_coordinates(1,:)), sum(camera_coordinates(2,:)), sum(camera_coordinates(3,:))];

WorldPts_Selected = [WorldPoints(:, 1), WorldPoints(:, 2), WorldPoints(:, 3)];
XW_centroid = 1 / size(WorldPts_Selected, 1) * [sum(WorldPts_Selected(1,:)), sum(WorldPts_Selected(2,:)), sum(WorldPts_Selected(3,:))];

prim_term = WorldPts_Selected - XW_centroid';
sec_term = camera_coordinates - XC_centroid';

H = prim_term  * sec_term';

[U,S,V] = svd(H);

d = sign(det(V*U'));

R = round(V*[1 0 0; 0 1 0; 0 0 d] * U');
t = round(- R * XW_centroid' + XC_centroid');

end




