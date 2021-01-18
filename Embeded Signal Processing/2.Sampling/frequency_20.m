clear;
clc;
fs=20;
n=4096;  %3996
t1 = -5;
t2 = 5;

[q,w]=impulse_train(t1,t2,n,fs)



subplot(3,2,1)
plot(q,w)
xlabel('t[sec]');
ylabel('p(t)');
grid on;
axis([-1 1,0 1])
subplot(3,2,2)
[q1,w1]=myfun_SA(q,w)
w2=abs(w1)
plot(q1,w2)
xlabel('f[HZ]');
ylabel('|P(t)|');
grid on;
axis([-30 30, 0 0.5]);


subplot(3,2,3)
tau=20*pi;
sinc_f=tau*sinc((tau*q)/(2*pi));
plot(q,sinc_f)
xlabel('t[sec]');
ylabel('x(t)');
grid on;
axis([- 1 1, -20 80])
subplot(3,2,4)
[q3,w3]=myfun_SA(q,sinc_f)
w4=abs(w3);
plot(q3,w4)
xlabel('f[HZ]');
ylabel('|X(t)|');
grid on;
axis([-30 30, 0 8]);



u=w.*sinc_f
subplot(3,2,5)
plot(q,u)
xlabel('t[sec]');
ylabel('y(t)');
grid on;
axis([-1 1, -20 80])

subplot(3,2,6)
[q5,w5]=myfun_SA(q,u)
w6=abs(w5);

plot(q5,w6)
xlabel('f[HZ]');
ylabel('|Y(t)|');
grid on;
axis([-30 30, 0 0.4])



fc=8 ;
[z, p, k] = buttap(5) ;
[num, den] = zp2tf(z,p,k) ;
[num, den] = lp2lp(num, den, 2*pi*fc) ;
[num_d, den_d] = bilinear( num, den, 1/abs(q(2)-q(1)) ) ;
y_out = filter( num_d, den_d, u ) ;
[f2,X3]=myfun_SA(q,u);
[f3,X4]=myfun_SA(q,y_out);
figure(2)
subplot(221)
plot(q,u)
xlabel('t[sec]');
ylabel('Before reconstruction y(t)');
grid on;
axis([-1 1, -20 80])
subplot(222)
plot(q,y_out)
xlabel('t[sec]');
ylabel('After reconstruction y(t)');
grid on;
axis([-1 1, -1 3.5])
subplot(223)
plot(f2,abs(X3))
xlabel('f[HZ]');
ylabel('Before reconstruction |Y(t)|');
grid on;
axis([-30 30 0 0.5])
subplot(224)
plot(f3,abs(X4))
xlabel('f[HZ]');
ylabel('After reconstruction |Y(t)|');
grid on;
axis([-30 30, 0 0.4])


  