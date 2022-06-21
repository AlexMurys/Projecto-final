clear; clc; close all;

R = 100;
C = 3.97e-6;

num = 1; 
den = [R*C, 1];
fc = 1/(2*pi*R*C);
W = 2*pi*[20:1:20000];
[H,w] = freqs(num,den,W);
semilogx(w/(2*pi),20*log10(abs(H)));
axis([0, 20000 -30 5]);
