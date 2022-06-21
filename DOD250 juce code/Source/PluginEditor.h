/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"
#include "PedalComponent.h"

using KnobNames = std::tuple<StringRef,StringRef>;

//==============================================================================
/**
*/
class DOD250AudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    DOD250AudioProcessorEditor (DOD250AudioProcessor&);
    ~DOD250AudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;

private:
    
    DOD250AudioProcessor& audioProcessor;
    
    Rectangle<int> PedalSize = {265,475};
    StringRef PedalName = "DOD250";
    StringRef PedalShortName = "OVERDRIVE";
    KnobNames PedalKnobNames = {"GAIN", "LEVEL"};
    Colour PedalColour = Colour(0xFFfce803);
    
    PedalComponent pedal{audioProcessor,PedalName,PedalShortName,PedalColour,PedalKnobNames};

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (DOD250AudioProcessorEditor)
};
