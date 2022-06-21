/*
  ==============================================================================

    DODClipper.h
    Created: 23 Apr 2022 11:00:06am
    Author:  Ale Murys

  ==============================================================================
*/

#pragma once

class DODClipper{
public:
    //Callbacks functions
    float processSample(float Vi);
    
    void prepare(float newFs);
    
    void setKnob(float newDrive); // I don't need because I don't have drive pot
    
    
    
private:
    
    const float eta = 1.0f;
    const float Is = 1e-9;
    const float Vt = 26e-3;
    
    float Fs = 48000.f;
    float Ts = 1.f/Fs;
    
    //Components
    float C4 = 4.7e-6;
    float R4 = Ts/(2*C4);
    
    float C5 = 1e-9;
    float R5 = Ts/(2*C5);
    
    float R8 = 10e3;
    float alpha = 1.f;
    float P1 = alpha*100e3; // I think I don't nedd multiply for alpha???
    
    
    // Combined Resistances
    float Gb = (1 + R8/R5 + R8/P1);
    float Ga = (1/R4 + 1/R8);
    float va = 0.f;
    
    //Initialize states
    float x4 = 0;
    float x5 = 0;
    float Vd = 0.f;
    float iter = 30;
    
    float thr = 0.000000001;
    
    void updateCoefficients();
    
};
