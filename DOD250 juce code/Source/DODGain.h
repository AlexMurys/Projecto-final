/*
  ==============================================================================

    DODGain.h
    Created: 24 Apr 2022 1:04:38pm
    Author:  Ale Murys

  ==============================================================================
*/

#pragma once

class DODGain{
public:
    float processSample(float Vi);
    
    void prepare(float  newFs);
    
    void setknob(float gainKnob);
    
    
private:
    void updateCoefficients();
    
    float Fs = 48000.f;
    float Ts = 1.f/Fs;
    
    float C1 = 10e-9;
    float R1 = Ts/(2*C1);
    
    float C2 = 47e-9;
    float R2 = Ts/(2*C2);
    
    float C3 = 25e-12;
    float R3 = Ts/(2*C3);
    
    float R4 = 10000.f;
    float R5 = 4700.f;
    float R6 = 1000000.f;
    float R7 = 481000.f; // suma de los paralelos de 22k con 470k
    
    float alpha = -0.5f;
    float P1 = 500e3 * (1-alpha);
    
    // RESISTENCIAS AGRUPADAS
    float G0 = 1/R1 + 1/R4;
    float G1 = 1 + R4/R7 - 1/(G0*R4);
    float G2 = 1 + R2/P1 + R5/P1;
    float G3 = 1/(G2*P1) + 1/R3 + 1/R6;
    float G4 = 1/(G3*R3) + 1/(G3*R6);
    float GR2 = 1 + R5/R2 + P1/R2;
    float GR3 = R3/(G2*P1) + R3/R6;
    float GR32 = (R2*R3)/(G2*P1);
    
    // ESTADOS
    float x1 = 0.f;
    float x2 = 0.f;
    float x3 = 0.f;
    
    //Coeficientes de filtros
    float b0 = 1/(G0*G1*G4*R1);
    float b1 = 1/(G0*G1*G4);
    float b2 = R2/(G2*G3*G4*P1);
    float b3 = 1/(G3*G4);
};
