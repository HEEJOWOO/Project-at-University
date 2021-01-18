function [YY]=RMSE(threshold,Y,Z)
for n=1:256
    for m=1:256
        if abs(Y(n,m))<threshold
            Y(n,m)=0;
        end
    end
end
C=idct2(Y).*256;
C=uint8(C);
for n=1:256
    
    for m=1:256
        YY(n,m)=abs(Z(n,m)-C(n,m))^2;
        p=sum(sum(YY));
         
    end
end
YY=sqrt((1/(256*256))*p);