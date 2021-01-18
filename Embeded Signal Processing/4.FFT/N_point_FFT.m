function [f_hat,Xk,N_MULT]=myfft(x,k);
N=length(x);%64
M=log2(N);%6�ܰ�
c=x;
tenth=zeros(1,N);%64���Ǳ����� 0���
oneth=zeros(1,M);%6���Ǳ����� 0���
s=1/N;%����Ʈ�� 1�� ���� �����ذ� ����
f_hat=linspace(-1/2,0.5-s,k);%�̻����ļ�

N_MULT=(N/2)*log2(N);%fft����Ƚ��

%10�� 2 �� 10��
for n=0:k-1%63
    x(n+1)=n;
end
X=dec2bin(x);
X=fliplr(X);
for n=0:k-1
    y(n+1)=cellstr(X(n+1,:));%������ ���ͷ� ������ ���� �迭�� ��ȯ,������ ���� ������
end
Y=bin2dec(y);%2������ 10������ �ٲ��ִ°�
Y=reshape(Y,1,[]);% �迭 ���� ����,������ ���� ������

for n=0:k-1
    x(n+1)=c(n+1);
    tenth(Y(n+1)+1)=x(n+1);
   
end
%������ ȸ������
for i=1:M%8����Ʈ 3�ܰ�
    first=2^(i-1);%1 2 3�ܰ�
    second=2^(M-i);%4, 2, 1 �ܰ�
    for t=1:2^i:N%1�ܰ� 1,3,5,7�� ��//2�ܰ� 1 5 //3�ܰ� 1
        for k=1:first%i 1 �� 1 ���� 4 t 1 k 1
            tm=tenth(t+k-1);%1�̵� 
            wm=second*(k-1);%0�̵�
            tenth(t+k-1)=tm+exp(-j*2*pi*wm/N)*tenth(t+k+first-1);%ȸ������
            tenth(t+k+first-1)=tm-exp(-j*2*pi*wm/N)*tenth(t+k+first-1);%ȸ������
        end
    end
end
xn=tenth;

Xk=zeros(1,N);
for i=1:N/2
    Xk((N/2)+i)=xn(i);   %���ʿ��� ���������� ����
    Xk(((N/2)+2)-i)=xn(i);%0.02�� �������� ��ȣ�� ����
%0~-1�� ����   
end