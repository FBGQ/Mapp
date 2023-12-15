function [I_out] = KernelFiltering(I,h)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(I,1)
    for j=1:size(I,2)       
      
        if i>2 && i<size(I,1)
          if j>2 & j <size(I,2)        
             
              I_out(i,j) = I(i-1,j-1)*h(3,3)+ I(i-1,j)*h(3,2)+I(i-1,j+1)*h(3,1) +...
                  I(i,j-1)*h(2,3)+I(i,j)*h(2,2)+I(i,j+1)*h(2,1)+...
                  I(i+1,j-1)*h(1,3)+I(i+1,j)*h(1,2)+I(i+1,j+1)*h(1,1);
                            
          end
        end
      
    end   
end
end

