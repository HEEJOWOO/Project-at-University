function [count,count1]=count_1(threshold,Y)%����� �Լ�
count=0;%����dct
count1=0;%����dct
for n=1:256
    for m=1:256
        if abs(Y(n,m)) ~=0
            count=count+1;
        end
        if abs(Y(n,m)) <0.001
            count=count+1;
        end
    end
end
%���� dct 0�� �ƴ� ���� �̱�
for n=1:256
    for m=1:256
        if abs(Y(n,m))<threshold
            Y(n,m)=0;
        end
        if abs(Y(n,m)) ~=0
            count1=count1+1;
        end
    end
end