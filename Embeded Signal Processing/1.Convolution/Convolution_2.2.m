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
x2= A*cos(2*pi*f2*n2+theta);
n3=[0,1,2,3,4,5,6,7,8,9,10];
x3=(-1).^n3;

[v,Y] = MAKE_CONV(x1,n1,x2,n2);
[v1,Y1] = MAKE_CONV(Y,v,x3,n3);
[v2,Y2] = MAKE_CONV(x2,n2,x3,n3);
[v3,Y3] = MAKE_CONV(x1,n1,Y2,v2);

subplot(411);
stem(n1,x1)
xlabel('n');
ylabel('x1[n]');
subplot(412);
stem(n2,x2)
xlabel('n');
ylabel('x2[n]');
subplot(413);
stem(n3,x3)
xlabel('n');
ylabel('x3[n]');
subplot(414);
stem(v1,Y1,'x')
hold on;
stem(v3,Y3,'k')
xlabel('n');
ylabel('y[n]');
legend('(x1[n]*x2[n])*x3[n]','x1[n]*(x2[n]*x3[n])');
