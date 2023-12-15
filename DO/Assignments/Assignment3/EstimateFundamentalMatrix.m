function F = EstimateFundamentalMatrix(p1, p2)

n = size(p1, 2);
A = zeros(n, 9);

for i = 1:n
    x1 = p1(1, i);
    y1 = p1(2, i);
    x2 = p2(1, i);
    y2 = p2(2, i);

    A(i, :) = [x1 * x2, x1 * y2, x1, y1 * x2, y1 * y2, y1, x2, y2, 1];

end

[~, ~, V] = svd(A);

F = V(:,end);

F = reshape(F, 3, 3);

end

