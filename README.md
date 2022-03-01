
### Accompanying scripts for the paper "Objective speech outcomes after surgical treatment for oral cancer: An acoustic analysis of a spontaneous speech corpus containing 32.850 tokens"

## How do I use these scripts

You need to download Praat first from [http://www.praat.org/](http://www.praat.org/).

## What do these scripts do
**PhonemeCOG+Mean+Skewness+Kurtosis.praat**: Praat script to calculate the Centre of Gravity (power=2, Hz) and the spectral tilt (550Hz-5500Hz, logarithmic: dB/decade)
 Both based on spectrograms with window=0.005 and band = [0, 5500] Hz

 Values are reported on half of the duration, the interval [start+duration/4, end-duration/4]: 
 Max, Min, Midpoint, point of maximal Intensity.
 The mean of CoG is also reported.

**PhonemeFormants.praat**: Praat script to calculate formants for phonemes

**PhonemeIntensity_Normalised.praat**: Praat script to calculate intensity in dB
Reports values: Max, Min, Median, 5% Perc., 95% Perc., Mean, S