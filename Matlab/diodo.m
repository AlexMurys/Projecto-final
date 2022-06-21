
clear; clc; close all;




% DC Offset Negativo

% Parámetros del diodo
Is = 1*10^-6;
Vt = 26*10^-3;
eta = 1.68;
% eta = 1;
% Is = 1*10^-15;
% Vt = 26*10^-3;

Fs = 48000; Ts = 1/Fs;

% Condensador DK Method
C = 80*10^-9;
R = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);

% Inicialización señal de salida
N = length(Vi);
Vo = zeros(N,1);

thr = 0.0000001;
x = 0; % variable de estado
Vd = 0; 
for n = 1:N 
    
    
    iter = 1;
    num = -Vi(n,1)/R + Is * (exp(Vd/(eta*Vt)) - 1) + Vd/R + x;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(Vd/(eta*Vt)) + 1/R;
        Vd = Vd - num/den;
        iter = iter + 1;
        num = -Vi(n,1)/R + Is * (exp(Vd/(eta*Vt)) - 1) + Vd/R + x;
    end
    
    %calcular la salida
    Vo(n,1) = Vd;
    
    %actualizacion de estado
    x = 2/R*(Vi(n,1) - Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);
%%

figure;
clear; 


%  DC Offset Positivo

% Parámetros del diodo
Is = 1*10^-6;
Vt = 26*10^-3;
eta = 1.68;

% Condensador DK Method
C = 80*10^-9;
Fs = 48000; Ts = 1/Fs;
R = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);

% Inicialización señal de salida
N = length(Vi);
Vout = zeros(N,1);

thr = 0.000001;
x = 0;
Vo = 0;
for n = 1:N 
    
    
    
    num = -Vi(n,1)/R + -Is * (exp(-Vo/(eta*Vt)) - 1) + Vo/R + x;
    iter = 1;
    while (iter < 50 && abs(num)>thr)
        den = (Is/(eta*Vt)) * exp(-Vo/(eta*Vt)) + 1/R;
        Vo = Vo - num/den;
        iter = iter + 1;
        num = -Vi(n,1)/R + -Is * (exp(-Vo/(eta*Vt)) - 1) + Vo/R + x;
    end
    %calcular la salida
    Vout(n,1) = Vo;
    
    %actualizacion de estado
    x = 2/R*(Vi(n,1) - Vo) - x;
end

% Waveforms
plot(t,Vi,t,Vout);
%%

figure;
clear; 
%RC LPF diodo recorte

% Parámetros del diodo
Is = 1*10^-6;
Vt = 26*10^-3;
eta = 1.68;
% eta = 1;
% Is = 1*10^-15;
% Vt = 26*10^-3;

% Condensador DK Method
R1 = 240000;
C = 80*10^-9;
Fs = 48000; Ts = 1/Fs;
R2 = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*2*t);

% Inicialización señal de salida
N = length(Vi);
Vo = zeros(N,1);

x = 0;
Vd = 0;
thr = 0.000000001;
for n = 1:N 
    
    num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
    iter = 1;
    while (iter < 50 && abs(num) > thr)
        
        den = (Is/(eta*Vt)) * exp(Vd/(eta*Vt)) + (1/R1 + 1/R2);
        Vd = Vd - num/den;
        num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
        iter = iter + 1;
    end
    % calcular la salida
    Vo(n,1) = Vd;
    
    % actualización variable de estado
    x = 2/R2*(Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);
%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RC LPF
% Is = 1*10^-6;
% Vt = 26*10^-3;
% eta = 1.68;
eta = 1;
Is = 1*10^-15;
Vt = 26*10^-3;

% Condensador DK Method
R1 = 240000;
C = 80*10^-12;
fc = 1/(2*pi*R1*C)
Fs = 48000; Ts = 1/Fs;
R2 = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);

% inicialización señal de salida
N = length(Vi);
Vo = zeros(N,1);

x = 0;
Vd = 0;
thr = 0.000000001;
for n = 1:N 
   
    iter = 1;
    num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) - Is * (exp(-Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
    while (iter < 50 && abs(num) > thr)
        den = (Is/(eta*Vt)) * exp(Vd/(eta*Vt)) + (Is/(eta*Vt)) * (exp(-Vd/(eta*Vt))) + (1/R1 + 1/R2);
        Vd = Vd - num/den;
        num = -Vi(n,1)/R1 + Is * (exp(Vd/(eta*Vt)) - 1) - Is * (exp(-Vd/(eta*Vt)) - 1) + (1/R1 + 1/R2)*Vd - x;
        iter = iter + 1;
    end
    % calcular la salida
    Vo(n,1) = Vd;
    
    % actualización de variables
    x = 2/R2*(Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);
%thd(Vo,Fs);
%%
figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Doble Diode Clipper RC LPF

% Parámetros del diodo
% Is = 1*10^-6;
% Vt = 26*10^-3;
% eta = 1.68;
eta = 1;
Is = 1*10^-15;
Vt = 26*10^-3;


R1 = 240000;
C = 80*10^-12;
fc = 1/(2*pi*R1*C)
Fs = 48000; Ts = 1/Fs;
R2 = Ts/(2*C);

t = [0:Ts:1].';
Vi = sin(2*pi*10*t);


N = length(Vi);
Vo = zeros(N,1);

x = 0;
Vd = 0;
thr = 0.0000000001;
for n = 1:N 
    
    
    iter = 1;
    num = -Vi(n,1)/R1 + 2*Is * sinh(Vd/(eta*Vt)) + (1/R1 + 1/R2)*Vd - x;
    while (iter < 50 && abs(num) > thr)
        
        den = 2*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + (1/R1 + 1/R2);
        Vd = Vd - num/den;
        num = -Vi(n,1)/R1 + 2*Is * sinh(Vd/(eta*Vt)) + (1/R1 + 1/R2)*Vd - x;
        iter = iter + 1;
    end
    % cálculo de salida
    Vo(n,1) = Vd;
    
    % actualizacion de variables
    x = 2/R2*(Vo(n,1)) - x;
end

% Waveforms
plot(t,Vi,t,Vo);
%thd(Vo,Fs);