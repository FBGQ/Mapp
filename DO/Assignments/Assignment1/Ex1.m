Xoff = -0.5;
Yoff = -0.5;
Zoff = 3;

BX = Box3D(Xoff,Yoff,Zoff);

f = 1;

plot3(BX(1,:), BX(2,:), BX(3,:),'*')

c2 = [f * BX(1,:)./BX(3,:); f * BX(2,:) ./BX(3,:);];

plot(c2(1,:), c2(2,:), '*')