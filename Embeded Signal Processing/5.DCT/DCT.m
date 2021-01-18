clear;
clc;

N=256;
N1=N;
N2=N;

Z=myfun_LoadImage('lena.raw', N1, N2);
figure(1)
subplot(131)
imshow(Z)
xlabel('(a)원본 이미지')
subplot(132)
X=fft2(Z);
Y=X./65536;
imshow(abs(Y))
xlabel('(b)DFT 변환 결과')
subplot(133)
X=ifft2(Y).*65536;
X=uint8(X);%범위를 벗어나거나 실수인 경우 가장 가까운 8비트 정수로 출력
imshow(X)
xlabel('(c)IDFT 역변환 이미지')

figure(2)
subplot(131)
imshow(Z)
xlabel('(a)원본 이미지')
subplot(132)
X=dct2(Z);
Y=X./256;
imshow(abs(Y))
xlabel('(b)DCT 변환 결과')
subplot(133)
C=idct2(Y).*256;
C=uint8(C);
imshow(C)
xlabel('(c)IDCT 역변환 이미지')


figure(3)

X=dct2(Z);
Y=X./256;
[C1,Y1]=th(0.01,Y);
[C2,Y2]=th(0.1,Y);
[C3,Y3]=th(0.25,Y);
[C4,Y4]=th(0.5,Y);
subplot(241)
imshow(C1)
xlabel('(a)문턱값 0.01')
subplot(242)
imshow(abs(Y1))
xlabel('(a)문턱값 0.01')
subplot(243)
imshow(C2)
xlabel('(b)문턱값 0.1')
subplot(244)
imshow(abs(Y2))
xlabel('(b)문턱값 0.1')
subplot(245)
imshow(C3)
xlabel('(c)문턱값 0.25')
subplot(246)
imshow(abs(Y3))
xlabel('(c)문턱값 0.25')
subplot(247)
imshow(C4)
xlabel('(d)문턱값 0.5')
subplot(248)
imshow(abs(Y4))
xlabel('(d)문턱값 0.5')


figure(4)
X=dct2(Z);
Y=X./256;

[count11,count1]=count_1(0.001,Y);
[count22,count2]=count_1(0.01,Y);
[count33,count3]=count_1(0.05,Y);
[count44,count4]=count_1(0.1,Y);
[count55,count5]=count_1(0.25,Y);
[count66,count6]=count_1(0.5,Y);


r=[0.001,0.01,0.05,0.1,0.25,0.5];
g=[count1/count11,count2/count22,count3/count33,count4/count44,count5/count55,count6/count66];
semilogy(r,g,'-or')
grid on;
xlabel('Threshold')
ylabel('Compression Ratio')

figure(5)
X=dct2(Z);
Y=X./256;%원본 이미지의 픽셀에 해당하는 gray scale 값


[YY_1]=RMSE(0.001,Y,Z);
[YY_2]=RMSE(0.01,Y,Z);
[YY_3]=RMSE(0.05,Y,Z);
[YY_4]=RMSE(0.1,Y,Z);
[YY_5]=RMSE(0.25,Y,Z);
[YY_6]=RMSE(0.5,Y,Z);

r=[0.001,0.01,0.05,0.1,0.25,0.5];
g=[YY_1,YY_2,YY_3,YY_4,YY_5,YY_6];
plot(r,g,'-ob')
grid on;
xlabel('Threshold')
ylabel('RMSE')

