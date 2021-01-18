clear;
clc;
k=64;%point º¯¼ö

f1=0.1;
f2=0.3;
n=linspace(0,k-1,k);
x=0.3*cos(2*pi*f1*n)+0.8*sin(2*pi*f2*n);

[f_hat,an,N_MULT]=myfft(x,k);
[f_hat1,Xk1,N_MULT1]=N_POINT_DFT(x,k);

subplot(2,1,1)
stem(n,x);
xlabel('n');
ylabel('x[n]');
subplot(2,1,2)
plot(f_hat,abs(an),':xr')
hold on;
plot(f_hat1,abs(Xk1),':ok')
xlabel('f_h_a_t N=64');
ylabel('|Xk|');
legend('FFT','DFT');
N_MULT
N_MULT1

grid on;
