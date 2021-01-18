function [f_hat,Xk]=N_P0INT_DFT(k,N)

f_hat=linspace(-1/2,0.48,N);

for i= 1:N
    
    for e= 1:N
        b(e)=k(e)*exp(-j*((2*pi*(e-1)*(i-1))/N));
        v(i)=(sum(b));
        
    end
end
for i=1:N/2
    Xk(N/2+i)=(v(i));
    Xk(((N/2)+1)-i)=(v(i));%0.02초 간격으로 신호가 나옴
   
end