/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
DOD250AudioProcessorEditor::DOD250AudioProcessorEditor (DOD250AudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{
    // Make sure that before the constructor has finished, you've set the
    // editor's size to whatever you need it to be.
    setSize (275, 485);
    pedal.setBounds(5,5,265,475);
    addAndMakeVisible(pedal);
}

DOD250AudioProcessorEditor::~DOD250AudioProcessorEditor()
{
}

//==============================================================================
void DOD250AudioProcessorEditor::paint (juce::Graphics& g)
{
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));
    
    g.setColour (juce::Colours::black);
    g.setFont (20.0f);
}

void DOD250AudioProcessorEditor::resized()
{
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..
}
