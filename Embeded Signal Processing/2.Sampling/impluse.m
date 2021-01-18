function [t,b]=impulse_train(t1,t2,n,fs) % 5 
t=linspace(t1,t2,n);
b=zeros(size(t));
o=round(n/(10*fs));
p=round((n/(10*fs))-1);
for i=1:o:n
    b(i:i+p:end)=1;
end

if sum(b)~=(t2-t1)*fs
    g=sum(b)-((t2-t1)*fs);
else
    g=0;
end

n0=n-(g*fs);
t=linspace(t1,t2,n0);
b=zeros(size(t));

for i=1:o:n-g %4091
    b(i:i+p:end)=1;
end