
### Accompanying scripts for the paper "Objective speech outcomes after surgical treatment for oral cancer: An acoustic analysis of a spontaneous speech corpus containing 32.850 tokens"

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) 
## How do I use these scripts

You need to download Praat first from [http://www.praat.org/](http://www.praat.org/).

## What do these scripts do

### Praat scripts 
**PhonemeCOG+Mean+Skewness+Kurtosis.praat**: Praat script to calculate the Centre of Gravity (power=2, Hz) and the spectral tilt (550Hz-5500Hz, logarithmic: dB/decade)
 Both based on spectrograms with window=0.005 and band = [0, 5500] Hz

 Values are reported on half of the duration, the interval [start+duration/4, end-duration/4]: 
 Max, Min, Midpoint, point of maximal Intensity.
 The mean of CoG is also reported.

**PhonemeFormants.praat**: Praat script to calculate formants for phonemes

**PhonemeIntensity_Normalised.praat**: Praat script to calculate intensity in dB
Reports values: Max, Min, Median, 5% Perc., 95% Perc., Mean, S

### R scripts

**group-analysis-consonants.Rmd** Comparing control and post-operatives oral cancer speech treatment groups in terms of consonants

**group-analysis-vowels.Rmd** Comparing control and post-operative oral cancer speech treatment group in terms of vowels

**within-female01.Rmd** Longitudinal (within speaker) analysis for the speaker called Female01

**within-male01.Rmd** Longitudinal (within speaker) analysis for the speaker called Male01

**fdr-corrections.Rmd** Contains the [False Discovery Rate](https://en.wikipedia.org/wiki/False_discovery_rate) corrections for the hypothesis tests 

### Extracted features

The extracted features an be found either in the analysis folder or these can be extracted from the original files and textgrids on [Zenodo](https://zenodo.org/record/6401713#.YkW74DyxVFM). 
