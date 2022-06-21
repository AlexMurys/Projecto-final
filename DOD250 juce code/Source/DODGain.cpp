/*
  ==============================================================================

    DODGain.cpp
    Created: 24 Apr 2022 1:04:38pm
    Author:  Ale Murys

  ==============================================================================
*/

#include "DODGain.h"

float DODGain::processSample(float Vi){
    float Vo = b0*Vi - b1*x1 - b2*x2 + b3*x3;
    float vx = Vi/(G0*G1*R1) - x1/(G0*G1);
    float vy = Vi/(G0*R1) + vx/(G0*R4) - x1/G0;
    
    x1 = (2/R1) * (Vi - vy) - x1;
    x2 = (2/R2) * ((Vo*G4 + (R2*x2)/(G2*G3*P1) - x3/G3)/GR2 +(R5*x2)/GR2 + (P1*x2)/GR2) - x2;
    x3 = (2/R3)*((Vo*G4 + (R2*x2)/(G2*G3*P1) - x3/G3)*GR3 - (R3/R6)*Vo - ((R2*R3)/(G2*P1))*x2 + R3*x3) - x3;
    return  Vo;
}

void DODGain::prepare(float newFS){
    if(Fs != newFS){
        Fs = newFS;
        updateCoefficients();
    }
}


void DODGain::setknob(float gainKnob){
    bool updateFlag = false;
    
    if(alpha != gainKnob){
        alpha = 0.00001f + 0.99998f * gainKnob;
        updateFlag = true;
    }
    if(updateFlag){
        updateCoefficients();
    }
    
}

void DODGain::updateCoefficients(){
    Ts = 1.f/Fs;
    R1 = Ts/(2*C1);
    R2 = Ts/(2*C2);
    R3 = Ts/(2*C3);
    
    P1 = 500e3 * (1-alpha);
    
    G0 = 1/R1 + 1/R4;
    G1 = 1 + R4/R7 + 1/(G0*R4);
    G2 = 1 + R2/P1 + R5/P1;
    G3 = 1/(G2*P1) + 1/R3 + 1/R6;
    G4 = 1/(G3*R3) + 1/(G3*R6);
    GR2 = 1 + R5/R2 + P1/R2;
    GR3 = R3/(G2*P1) + R3/R6;
    GR32 = (R2*R3)/(G2*P1);
    
    b0 = 1/(G0*G1*G4*R1);
    b1 = 1/(G0*G1*G4);
    b2 = R2/(G2*G3*G4*P1);
    b3 = 1/(G3*G4);
}
