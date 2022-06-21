%******** DK method *********

Fs = 48000;
Ts = 1/Fs;

%Componentes
C1 = 3.97e-6;
R1 = Ts/(2*C1);
R2 = 100;

G = (1/R1 + 1/R2);
fc = 1/(2*pi*R2*C1);

%%% Tomamos la respuesta de impulso del filtro de manera que podamos hacer
%%% un plot de respuesta en frecuencia
% Respuesta de impulso
Vi = [1; zeros(2047,1)];
N = length(Vi);

%Coeficientes del filtro
b0 = 1/(G*R2);
b1 = 1/G;

x1 = 0; %inicilización del estado

for n = 1:N
    Vo(n,1) = b0 * Vi(n,1) + b1 * x1;
    x1 = (2/R1) * Vo(n,1) - x1;
end



subplot(3, 1, 1);
[HDK,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(HDK)), 'b', 'LineWidth', 2);
grid on
axis([20 20000 -30 5]);
grid on;
xlabel('Frecuencia (Hertz)', 'FontName', 'Times', 'Fontsize', 14);
xticks([20 100 200 400 800 1500  5000 10000 20000]);
yticks([-30 -20 -10 -3 0]);
%xticklabels({'})
ylabel('Amplitud (dB)', 'FontName', 'Times', 'Fontsize', 14);
title ('DK method: Filtro paso bajo RC de 1º Orden', 'FontName', 'Times', 'Fontsize', 24);

atenuacion = -20*log10(abs(HDK));
subplot(3, 1, 2);
semilogx(W, atenuacion, 'b', 'LineWidth', 2);
axis([20 20000 -5 30]);
xlabel('Frecuencia (Hertz)', 'FontName', 'Times', 'Fontsize', 14);
ylabel('Atenuación (dB)', 'FontName', 'Times', 'Fontsize', 14);
xticks([20 100 200 400 800 1500  5000 10000 20000]);
yticks([0 3 10 20 30]);
grid on;

fase = (180/pi) * unwrap(angle(HDK));
subplot(3, 1, 3);
semilogx(W*2*pi, fase, 'b', 'LineWidth', 2);
axis([0 4000*pi -100 100]);
xlabel('Frecuencia angular (rad/s)', 'FontName', 'Times', 'Fontsize', 14);
ylabel('Fase (º)', 'FontName', 'Times', 'Fontsize', 14);
xticks([0 40*pi 400*pi 2000*pi 4000*pi]);
grid on
%%

%******** Transformada Laplace *********

clear; clc; close all;

R = 100;
C = 3.97e-6;

num = 1; 
den = [R*C, 1];
fc = 1/(2*pi*R*C);
W = 2*pi*[20:1:20000];
[H,w] = freqs(num,den,W);
subplot(3, 1, 1);
semilogx(w/(2*pi),20*log10(abs(H)),'b', 'LineWidth', 2);
axis([0, 20000 -30 5]);

grid on;
xlabel('Frecuencia (Hertz)', 'FontName', 'Times', 'Fontsize', 14);
xticks([20 100 200 400 800 1500  5000 10000 20000]);
yticks([-30 -20 -10 -3 0]);
ylabel('Amplitud (dB)', 'FontName', 'Times', 'Fontsize', 14);
title ('TF Laplace: Filtro paso bajo RC de 1º orden', 'FontName', 'Times', 'Fontsize', 24);

atenuacion = -20*log10(abs(H));
subplot(3, 1, 2);
semilogx(w/(2*pi), atenuacion, 'b', 'LineWidth', 2);
axis([0 20000 -5 30]);
xlabel('Frecuencia (Hertz)', 'FontName', 'Times', 'Fontsize', 14);
ylabel('Atenuación (dB)', 'FontName', 'Times', 'Fontsize', 14);
xticks([20 100 200 400 800 1500  5000 10000 20000]);
yticks([0 3 10 20 30]);
grid on;

fase = (180/pi) * unwrap(angle(H));
subplot(3, 1, 3);
semilogx(w, fase, 'b', 'LineWidth', 2);
axis([0 4000*pi -100 100]);
xlabel('Frecuencia angular (rad/s)', 'FontName', 'Times', 'Fontsize', 14);
ylabel('Fase (º)', 'FontName', 'Times', 'Fontsize', 14);
xticks([0 40*pi 400*pi 2000*pi 4000*pi]);
grid on
hold on
%%

%******** Transformada Bilineal *********

Fs = 48000;

%Conversión analógica a digital

[numD,denD] = bilinear(num, den, Fs);
figure;
freqz(numD, denD);
[Hd, F] = freqz(numD, denD, 2048, Fs);
subplot(3, 1, 1);
semilogx(w/(2*pi),20*log10(abs(H)),'b', 'LineWidth', 2);
hold on
semilogx(F, 20*log10(abs(Hd)),'m--', 'LineWidth', 2);
axis([20 20000, -30 5]);
xlabel('Frecuencia (Hertz)', 'FontName', 'Times', 'Fontsize', 14);
xticks([20 100 200 400 800 1500  5000 10000 20000]);
yticks([-30 -20 -10 -3 0]);
ylabel('Amplitud (dB)', 'FontName', 'Times', 'Fontsize', 14);
title ('TF Laplace/TF Bilineal: Filtro paso bajo RC de 1º orden', 'FontName', 'Times', 'Fontsize', 24);
legend('TF Laplace', 'TF Bilineal');
grid on

atenuacion2 = -20*log10(abs(Hd));
subplot(3, 1, 2);
semilogx(w/(2*pi), atenuacion, 'b', 'LineWidth', 2);
hold on
semilogx(F, atenuacion2, 'm--', 'LineWidth', 2);
axis([20 20000 -5 30]);
xlabel('Frecuencia (Hertz)', 'FontName', 'Times', 'Fontsize', 14);
ylabel('Atenuación (dB)', 'FontName', 'Times', 'Fontsize', 14);
xticks([20 100 200 400 800 1500  5000 10000 20000]);
yticks([0 3 10 20 30]);
grid on;

fase2 = (180/pi) * unwrap(angle(Hd));
subplot(3, 1, 3);
semilogx(w, fase, 'b', 'LineWidth', 2);
hold on
semilogx(F*2*pi, fase2, 'm--', 'LineWidth', 2);
axis([40*pi 4000*pi -100 100]);
xlabel('Frecuencia angular (rad/s)', 'FontName', 'Times', 'Fontsize', 14);
ylabel('Fase (º)', 'FontName', 'Times', 'Fontsize', 14);
xticks([0 40*pi 400*pi 2000*pi 4000*pi]);
grid on

