clear;
clc;


figure(1)
aa=roots([1 5]);%zero
aaa=roots([1 2 5]);%pole
a_1=real(aa);
a_11=imag(aa);
a_2=real(aaa);
a_22=imag(aaa);
plot(a_1,a_11,'ok')
hold on;
plot(a_2,a_22,'xk')
grid on;
xlim([-6 0])
ylim([-2.5 2.5])
xlabel('Real(s)')
ylabel('Imag(s)')

figure(2)
[r,p,k]=residue([1 5],[1 2 5]);
t=linspace(0,10,1000);
kk=0;
for i =1:length(r)
    aa=r(i)*exp(p(i)*t);
    kk=aa+kk;
end
plot(t,kk)
grid on;
xlabel('t[sec]')
ylabel('h(t)')


figure(3)
w=-4:0.01:4;
HW_1=0;
for i=1:length(r)
    HW=r(i)./((j*w)-p(i))
    HW_1=HW+HW_1;
end

plot(w,abs(HW_1))
grid on;
xlabel('|H(w)|')
ylabel('Frequency w[rad/sec]')

figure(4)
subplot(311)
p=[-1+(2i);-1-(2i)];
z=[-5];
[b,a]=zp2tf(z,p,1);
[r,p,k]=residue(b,a);
t=linspace(0,10,1000);
kk=0;
for i =1:length(r)
    aa=r(i)*exp(p(i)*t);
    kk=aa+kk;
end
plot(t,kk)
grid on;
ylabel('h(t),System #1')

subplot(312)
p=[(2i);(-2i)];
z=[-5];
[b,a]=zp2tf(z,p,1);
[r,p,k]=residue(b,a);
t=linspace(0,10,1000);
kk=0;
for i =1:length(r)
    aa=r(i)*exp(p(i)*t);
    kk=aa+kk;
end
plot(t,kk)
grid on;
ylabel('h(t),System #2')
subplot(313)
p=[1+(2i);1-(2i)];
z=[-5];
[b,a]=zp2tf(z,p,1);
[r,p,k]=residue(b,a);
t=linspace(0,10,1000);
kk=0;
for i =1:length(r)
    aa=r(i)*exp(p(i)*t);
    kk=aa+kk;
end
plot(t,kk)
grid on;
ylabel('h(t),System #3')
xlabel('t[sec]')

figure(5)
r=1;
theta=linspace(0,2*pi,100);
x=r*cos(theta);
y=r*sin(theta);
plot(x,y,'.-')
hold on;
aa=roots([1 -0.3]);%zero
aaa=roots([1 0.3 0.36 0.108]);%pole
a_1=real(aa);
a_11=imag(aa);
a_2=real(aaa);
a_22=imag(aaa);
plot(a_1,a_11,'ok')
hold on;
plot(a_2,a_22,'xk')
grid on;
xlabel('Real(z)')
ylabel('Imag(z)')

figure(6)
[r,p,k]=residue([1 -0.3],[1 0.3 0.36 0.108]);
n=linspace(0,20,21);
un=zeros(1,length(n));
if n>=0
    un=1
end
kk=0;
for i =1:length(r)
    aa=r(i)*(p(i).^n).*un
    kk=aa+kk;
end
for i=1:20
    rk(i+1)=kk(i)
end
stem(n,rk)
grid on;
xlabel('n')
ylabel('h[n]')

figure(7)
w=-3.2:0.01:3.2;
HW_1=0;
for i=1:length(r)
    HW=r(i)./((exp(j*w))-p(i))
    HW_1=HW+HW_1;
end

plot(w,abs(HW_1))
grid on;
xlim([-3.2 3.2])
ylim([0.2 1.8])
xlabel('Frequency §Ù [rad]')
ylabel('|H(§Ù)|')



figure(8)
subplot(311)
r=0.5;
rr=r/sqrt(2);
p=[0.3536+0.3536i;0.3536-0.3536i];
z=[-5];
[b,a]=zp2tf(z,p,1);
[r,p,k]=residue(b,a);
n=linspace(0,20,21);
un=zeros(1,length(n));
if n>=0
    un=1
end
kk=0;
for i =1:length(r)
    aa=r(i)*(p(i).^n).*un
    kk=aa+kk;
end
for i=1:20
    rk(i+1)=kk(i)
end
stem(n,rk)
grid on
ylabel('h[n],System #1')
subplot(312)
r=1;
rr=r/sqrt(2);
p=[0.7071+0.7071i;0.7071-0.7071i];
z=[-5];
[b,a]=zp2tf(z,p,1);
[r,p,k]=residue(b,a);
n=linspace(0,20,21);
un=zeros(1,length(n));
if n>=0
    un=1
end
kk=0;
for i =1:length(r)
    aa=r(i)*(p(i).^n).*un
    kk=aa+kk;
end
for i=1:20
    rk(i+1)=kk(i)
end
stem(n,rk)
grid on
ylabel('h[n],System #2')
subplot(313)
r=1.5;
rr=r/sqrt(2);
p=[1.0607+1.0607i;1.0607-1.0607i];
z=[-5];
[b,a]=zp2tf(z,p,1);
[r,p,k]=residue(b,a);
n=linspace(0,20,21);
un=zeros(1,length(n));
if n>=0
    un=1
end
kk=0;
for i =1:length(r)
    aa=r(i)*(p(i).^n).*un
    kk=aa+kk;
end
rk=zeros(1,length(kk))
for i=1:20
    rk(i+1)=kk(i)
end
stem(n,rk)
grid on
ylabel('h[n],System #3')
xlabel('n')




