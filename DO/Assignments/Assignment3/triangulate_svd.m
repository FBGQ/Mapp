function pest = triangulate_svd(q1, q2, Rs, Cs, K)
    
    R1 = Rs(:,:,1);
    R2 = Rs(:,:,2);

    C1 = Cs(:,1);
    C2 = Cs(:,2);
    
    t1 = -R1 * C1; 
    t2 = -R2 * C2;

    P1 = K * [R1, t1];
    P2 = K * [R2, t2];

    a = P1(3,:) * q1(1) - P1(1,:);
    b = P1(3,:) * q1(2) - P1(2,:);
    c = P2(3,:) * q2(1) - P2(1,:);
    d = P2(3,:) * q2(2) - P2(2,:);

    A = [a; b; c; d];

    [U, S, V] = svd(A); 
    
    X = V(:,end);

    pest = X;
    pest = pest ./ pest(4);
    
end