clear;
clc;
N=50;
N1=1024
L=30;
PL=zeros(1,N);
PL_1=zeros(1,N1);
for o=1:L
    PL(o)=1;
    PL_1(o)=1;
end

n=linspace(0,N-1,N);
[f_hat,Xk,N_MULT]=N_POINT_DFT(PL,N);
[f_hat1,Xk1,N_MULT1]=N_POlNT_DFT(PL_1,N1);

subplot(2,1,1)
stem(n,PL);
xlabel('n');
ylabel('x[n]');
grid on;
subplot(2,1,2)
plot(f_hat,abs(Xk),'ro');
axis([-0.5 0.5,0,L]);
xlabel('f_h_a_t');
ylabel('|Xk|');
grid on;
hold on;
plot(f_hat1,abs(Xk1),'k-');
axis([-0.5 0.5,0,L]);
xlabel('f_h_a_t');
ylabel('|Xk|');
grid on;
N_MULT
N_MULT1