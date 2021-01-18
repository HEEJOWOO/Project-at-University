clear;
clc;
figure(1);

A=1;
f=0.05;
theta=0;
n1=[-5,-4,-3,-2,-1,0,1,2,3,4,5];
x1=A*cos(2*pi*f*n1+theta);
n2=[0,1,2,3,4,5];
x2=[1,2,3,4,5,6];


[v1,Y1] = MAKE_CONV(x2,n2,x1,n1);
[v,Y] = MAKE_CONV(x1,n1,x2,n2);

subplot(311);
stem(n1,x1)
xlabel('n');
ylabel('x1[n]');
subplot(312);
stem(n2,x2)
xlabel('n');
ylabel('x2[n]');
subplot(313);
stem(v,Y,'x')
hold on;
stem(v1,Y1,'k')
xlabel('n');
ylabel('y[n]');
legend('x1[n]*x2[n]','x2[n]*x1[n]')

