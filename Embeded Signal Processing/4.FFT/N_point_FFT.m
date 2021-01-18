function [f_hat,Xk,N_MULT]=myfft(x,k);
N=length(x);%64
M=log2(N);%6단계
c=x;
tenth=zeros(1,N);%64개의길이의 0행렬
oneth=zeros(1,M);%6개의길이의 0행렬
s=1/N;%포인트로 1의 길이 나눠준값 맵핑
f_hat=linspace(-1/2,0.5-s,k);%이산주파수

N_MULT=(N/2)*log2(N);%fft곱셈횟수

%10진 2 진 10진
for n=0:k-1%63
    x(n+1)=n;
end
X=dec2bin(x);
X=fliplr(X);
for n=0:k-1
    y(n+1)=cellstr(X(n+1,:));%문자형 벡터로 구성된 셀형 배열로 변환,이진수 열을 행으로
end
Y=bin2dec(y);%2진수를 10진수로 바꿔주는것
Y=reshape(Y,1,[]);% 배열 형태 변경,십진수 열을 행으로

for n=0:k-1
    x(n+1)=c(n+1);
    tenth(Y(n+1)+1)=x(n+1);
   
end
%선형도 회전인자
for i=1:M%8포인트 3단계
    first=2^(i-1);%1 2 3단계
    second=2^(M-i);%4, 2, 1 단계
    for t=1:2^i:N%1단계 1,3,5,7이 들어감//2단계 1 5 //3단계 1
        for k=1:first%i 1 딥 1 위스 4 t 1 k 1
            tm=tenth(t+k-1);%1이됨 
            wm=second*(k-1);%0이됨
            tenth(t+k-1)=tm+exp(-j*2*pi*wm/N)*tenth(t+k+first-1);%회전인자
            tenth(t+k+first-1)=tm-exp(-j*2*pi*wm/N)*tenth(t+k+first-1);%회전인자
        end
    end
end
xn=tenth;

Xk=zeros(1,N);
for i=1:N/2
    Xk((N/2)+i)=xn(i);   %왼쪽에서 오른쪽으로 매핑
    Xk(((N/2)+2)-i)=xn(i);%0.02초 간격으로 신호가 나옴
%0~-1로 매핑   
end