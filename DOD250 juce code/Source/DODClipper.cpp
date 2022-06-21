/*
  ==============================================================================

    DODClipper.cpp
    Created: 23 Apr 2022 11:00:06am
    Author:  Ale Murys

  ==============================================================================
*/

#include "DODClipper.h"
#include <JuceHeader.h>

float DODClipper::processSample(float Vi){
    float p = Vi/(Ga*R4) + R8*x5; // parte lineal del circuito
    
    int i = 1;
    float b = 1.f; //factor de amortiguamiento
    float fd = p + Vd/(Ga*R8) - R8*2*Is * sinh(Vd/(eta*Vt)) - Vd*Gb; // función f(x)'
    while(i < iter && abs(fd) > thr){
        float den = -R8*2*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + 1/(Ga*R8) - Gb; //derivada de la función
        float Vnew = Vd - b*fd/den; //método Newton-Raphson
        float fn = p + Vnew/(Ga*R8) - R8*2*Is * sinh(Vnew/(eta*Vt)) - Vnew*Gb; //nuevo valor de f(x)
        
        if(abs(fn) > abs(fd)){ // ajuste del factor de amortiguamiento si fuese necesario
            b *= 0.5f;
        }
        else{
            Vd = Vnew;
            b = 1.f;
        }
        fd = p + Vd/(Ga*R8) - R8*2*Is * sinh(Vd/(eta*Vt)) - Vd*Gb;
        i++;
    }
    
    float Vo = Vd;
    //actualización de variables
    va = Vi/(Ga*R4) + Vd/(R8*Ga);
    x4 = (2/R4)*(Vi - va) - x4;
    x5 = (2/R5)*(Vd) - x5;
    
    return  Vo;
}

void DODClipper::prepare(float newFs){
    if(Fs != newFs){
        updateCoefficients();
    }
}

void DODClipper::setKnob(float newDrive){
    bool updateFlag = false;
    
    if(alpha != newDrive){
        alpha = 0.00001f + 0.99998f * newDrive;
        updateFlag = true;
    }
    if(updateFlag){
        updateCoefficients();
    }
}

void DODClipper::updateCoefficients(){
    
     R4 = Ts/(2*C4);
     R5 = Ts/(2*C5);
     P1 = alpha*100e3;
    
    // Combined Resistances
     Gb = (1 + R8/R5 + R8/P1);
     Ga = (1/R4 + 1/R8);
}

