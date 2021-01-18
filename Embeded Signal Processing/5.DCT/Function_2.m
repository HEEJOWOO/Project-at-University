function [C,Y]=th(threshold,Y)%문턱값 미안 0 
for n=1:256
    for m=1:256
        if abs(Y(n,m))<threshold
            Y(n,m)=0;
        end
    end
end
C=idct2(Y).*256;
C=uint8(C);