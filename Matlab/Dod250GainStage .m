clear; clc; close all;
Fs = 48000;
Ts = 1/Fs;
%Componentes
C1 = 10e-9;
R1 = Ts/(2*C1);

C2 = 47e-9;
R2 = Ts/(2*C2);

C3 = 25e-12;
R3 = Ts/(2*C3);

R4 = 10000;
R5 = 4700;
R6 = 1000000;
R7 = 481000; % suma de los paralelos de 22k con 470k

alpha = .99;

for alpha = 0.01:.1:.99
    P1 = 500000 * alpha;
    
    % RESISTENCIAS AGRUPADAS
    G0 = 1/R1 + 1/R4;
    G1 = 1 + R4/R7 + 1/(G0*R4);
    G2 = 1 + R2/P1 + R5/P1;
    G3 = 1/(G2*P1) + 1/R3 + 1/R6;
    G4 = 1/(G3*R3) + 1/(G3*R6);
    GR2 = 1 + R5/R2 + P1/R2;
    GR3 = R3/(G2*P1) + R3/R6;
    GR32 = (R2*R3)/(G2*P1);
    
    % ESTADOS
    x1 = 0;
    x2 = 0;
    x3 = 0;
    
    b0 = 1/(G0*G1*G4*R1);
    b1 = 1/(G0*G1*G4);
    b2 = R2/(G2*G3*G4*P1);
    b3 = 1/(G3*G4);
    
    %RESPUESTA DE IMPULSO 
    Vi = [1;zeros(4095,1)];
    N = length(Vi);
    Vo = zeros(N,1);
    
    for n=1:N
        Vo(n,1) = b0*Vi(n,1) - b1*x1 - b2*x2 + b3*x3;
        vx = Vi(n,1)/(G0*G1*R1) - x1/(G0*G1);
        vy = Vi(n,1)/(G0*R1) + vx/(G0*R4) - x1/G0;
        
        
        %ActualizaciÛn de estados
        x1 = (2/R1) * (Vi(n,1) - vy) - x1;
        x2 = (2/R2) * (vx/GR2 +(R5*x2)/GR2 + (P1*x2)/GR2) - x2;
        %vxTop = Vo(n,1)*G4 + (R2*x2)/(G2*G3*P1) - x3/G3 ----> es vx para el estado x3;
        x3 = (2/R3)*((Vo(n,1)*G4 + (R2*x2)/(G2*G3*P1) - x3/G3)*GR3 - (R3/R6)*Vo(n,1) - ((R2*R3)/(G2*P1))*x2 + R3*x3) - x3;     
    end
    [H,F] = freqz(Vo,1,4096,Fs);
    %plot(F , 20*log10(abs(H)));
    semilogx(F , 20*log10(abs(H)));
    xlabel('Frecuencia (Hertz)', 'FontName', 'Times', 'Fontsize', 14);
    xticks([10 100 1000 10000 20000]);
    yticks([-10 0 10 20 30 40 50]);
    ylabel('Amplitud (dB)', 'FontName', 'Times', 'Fontsize', 14);
    title ('Respuesta en frecuencia DOD 250, C1 = 10nF, C3 = 25pF', 'FontName', 'Times', 'Fontsize', 24);
    grid on
    hold on;
end
axis([10 20000 -30 50]);
hold off;

