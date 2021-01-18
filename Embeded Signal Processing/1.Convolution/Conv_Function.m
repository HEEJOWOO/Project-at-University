function [v,Y] = make_conv(x1,n1,x2,n2)
if x2(1)==0
    h =fliplr(x2);
else
    h=x2;
end

m=length(x1);
n=length(h);
X=[x1,zeros(1,n)];
H=[h,zeros(1,m)];
v=linspace(min(n1)+min(n2),max(n1)+max(n2),n+m-1);
for i=1:n+m-1
    Y(i)=0;
        for j=1:m;
            if(i-j+1>0)
                a=Y(i)+X(j)*H(i-j+1);
                Y(i)=prod(a);
            else
            end
        end
end


