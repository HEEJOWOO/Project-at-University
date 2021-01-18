clear;
clc;
figure(1);

A=1;
f1=0.1;
f2=0.05;
theta=0;
n1=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
x1=A*cos(2*pi*f1*n1+theta);
n2=[-5,-4,-3,-2,-1,0,1,2,3,4,5];
x2=A*cos(2*pi*f2*n2+theta);


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
stem(v,Y)
xlabel('n');
ylabel('y[n]');