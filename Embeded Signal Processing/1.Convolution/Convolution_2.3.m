clear;
clc;
figure(1);

A=1;
f=0.1;
theta=0;
n1=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
x1=A*cos(2*pi*f*n1+theta);
x11=A*cos(2*pi*f*(n1-5)+theta);

n2 = [0,1,2,3,4,5];
h = (0.5).^n2;

figure(1)
[v,Y] = MAKE_CONV(x1,n1,h,n2);
subplot(311);
stem(n1,x1,'k')
xlabel('n');
ylabel('x[n]');
subplot(312);
stem(n2,h,'k')
xlabel('n');
ylabel('h[n]');
subplot(313);
stem(v,Y,'k')
xlabel('n');
ylabel('y[n]');

for r=1:length(n1)-5
    e(r)=x11(r)
    c=[e,zeros(1,5)]
end
x11=c;  


figure(2)
[v1,Y1] = MAKE_CONV(x11,n1,h,n2);
subplot(311);
stem(n1,x11,'r')
xlabel('n');
ylabel('x[n]');
subplot(312);
stem(n2,h,'k')
xlabel('n');
ylabel('h[n]');
subplot(313);
stem(v1,Y1,'r')
xlabel('n');
ylabel('y[n]');