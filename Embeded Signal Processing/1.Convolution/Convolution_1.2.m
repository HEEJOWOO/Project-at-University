clear;
clc;
figure(1);

n1=[-5,-4,-3,-2,-1,0,1,2,3,4,5];
x1=[0,0,0,0,0,1,1,1,0,0,0];
n2=[-5,-4,-3,-2,-1,0,1,2,3,4,5];
x2=[0,0,0,1,1,1,1,1,0,0,0];


[v,Y] = MAKE_CONV(x1,n1,x2,n2)
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