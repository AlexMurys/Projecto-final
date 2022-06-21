
clear; clc; close all;

eta = 1;
Is = 1e-15; % Is 1e-12 1e-9 1e-6 para las modificaciones 
Vt = 26e-3;

Fs = 48000; Ts = 1/Fs;
% Componentes 
C4 = 4.7e-6;
R4 = Ts/(2*C4);

C5 = 1e-9;
R5 = Ts/(2*C5);

R8 = 10e3;
alpha = 1;
P1 = alpha*100e3;

% Resistencias combinadas
Gb = (1 + R8/R5 + R8/P1);
Ga = (1/R4 + 1/R8);

%%%%%%%%%%%%%%%% DAMPED Newton-Raphson

t = [0:Ts:1].';
Vi = 1*sin(2*pi*400*t);

% Inicialización de señal de salida
N = length(Vi);
Vo = zeros(N,1);
%inicialización de estados
x4 = 0;
x5 = 0;

thr = 0.000000001; %umbral de paso por cero eje Y
Vd = 0;
for n = 1:N 
    
    p = Vi(n,1)/(Ga*R4) + R8*x5; %p son los componentes lineales de esta etapa
    iter = 1;
    b = 1;
    fd =  p + Vd/(Ga*R8) - 2*Is * sinh(Vd/(eta*Vt)) - Vd*Gb; %f(x) 
    
    %mientras el numero de iteraciones sea menor a 50 y el valor absoluto de la función sea mayor al umbral
    while(iter<50 && abs(fd) > thr) 
        
        den = -R8*2*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + 1/(Ga*R8) - Gb; %f'(x)
        Vnew = Vd - b*fd/den;
        %nuevo valor de f(x)
        fn = p +  Vnew/(Ga*R8) - 2*Is * sinh(Vnew/(eta*Vt)) - Vnew*Gb;
        if (abs(fn) > abs(fd))
            b = b/2;
        else
            Vd = Vnew;
            b = 1;
        end
        fd =  p + Vd/(Ga*R8) - 2*Is * sinh(Vd/(eta*Vt)) - Vd*Gb;
        iter = iter + 1;
    end
    
    % cálculo de señal de salida
    Vo(n,1) = (Vd);
    
    va = Vi(n,1)/(Ga*R4) + Vd/(R8*Ga);
    
    % Actualización de variables
    x4 = (2/R4)*(Vi(n,1)- va) - x4;
    x5 = (2/R5)*(Vd) - x5;
end

% Forma de onda
ttt = 200;
plot(t(1:ttt),Vi(1:ttt),t(1:ttt),Vo(1:ttt));
axis([t(1) t(ttt) -2 2]);
%Distorsion total armónica
thd(Vo, Fs);


