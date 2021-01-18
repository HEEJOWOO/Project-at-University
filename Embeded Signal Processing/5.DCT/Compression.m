function [count,count1]=count_1(threshold,Y)%압축률 함수
count=0;%원본dct
count1=0;%압축dct
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
%압축 dct 0이 아닌 갯수 뽑기
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