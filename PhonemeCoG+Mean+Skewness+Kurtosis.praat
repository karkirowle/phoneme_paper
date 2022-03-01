
#
# Copyright: 2021, R.J.J.H. van Son and the Netherlands Cancer Institute
# License: GNU GPL v2 or later
# email: r.j.j.h.vanson@gmail.com, r.v.son@nki.nl
#
#  PhonemeCOG+Mean+Skewness+Kurtosis.praat: Praat script to calculate the Centre of Gravity (power=2, Hz) and the spectral tilt (550Hz-5500Hz, logarithmic: dB/decade)
# Both based on spectrograms with window=0.005 and band = [0, 5500] Hz
#
# Values are reported on half of the duration, the interval [start+duration/4, end-duration/4]: 
# Max, Min, Midpoint, point of maximal Intensity.
# The mean of CoG is also reported.
#
#
#     Copyright (C) 2021  R.J.J.H. van Son and the Netherlands Cancer
Institute
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA
#




sourcePath$ = "./";
targetPath$ = "Database/";

createDirectory: targetPath$

.textGridList = Create Strings as file list: "TextGrids", sourcePath$ + "*_ID.TextGrid"
.nFiles = Get number of strings

for .f to .nFiles
	selectObject: .textGridList
	.textGridName$ = Get string: .f
	.basename$ = replace$(.textGridName$, "_ID.TextGrid", "", 0)

	.audioName$ = .basename$ + ".wav"

	
	# Add identification labels to annotation
	.audio = Read from file: sourcePath$ + .audioName$
	.textGrid = Read from file: sourcePath$ + .textGridName$
	.numTiers = Get number of tiers
	for .t to .numTiers
		selectObject: .textGrid
		.tierName$ = Get tier name: .t
		if .tierName$ == "ORT-MAU"
			tierORT = .t
		elsif .tierName$ == "TRL-MAU"
			tierTRL = .t
		elsif .tierName$ == "MAU"
			tierMAU = .t
		elsif .tierName$ == "TRN"
			tierTRN = .t
		endif
	endfor

	# Measurements
	# Intensity
	selectObject: .audio
	.intensity = To Intensity: 100, 0, "yes"
	
	# Create CoG and spectral tilt
	selectObject: .audio
	.duration = Get total duration
	.spectrogram = noprogress To Spectrogram: 0.005, 5500, 0.002, 20, "Gaussian"
	# Create CoG and Spectral tilt as sound files
	.cog = Create Sound from formula: "CoG", 1, 0, .duration, 500, "0"
	.numSamples = Get number of samples
	.tilt = Create Sound from formula: "SpectralTilt", 1, 0, .duration, 500, "0"
	.sd = Create Sound from formula: "SD", 1, 0, .duration, 500, "0"
	.skewness = Create Sound from formula: "Skewness", 1, 0, .duration, 500, "0"
	.kurtosis = Create Sound from formula: "kurtosis", 1, 0, .duration, 500, "0"
	.cm = Create Sound from formula: "CM", 1, 0, .duration, 500, "0"
	for .s to .numSamples
		selectObject: .cog
		.t = Get time from sample number: .s
		
		selectObject: .spectrogram
		.spectralSlice = To Spectrum (slice): .t
		# CoG
		selectObject: .spectralSlice
		.cogValue = Get centre of gravity: 2
		selectObject: .cog
		Set value at sample number: 0, .s, .cogValue
		# SD
		selectObject: .spectralSlice
		.sdValue = Get standard deviation: 2
		selectObject: .sd
		Set value at sample number: 0, .s, .sdValue
		# Skewness
		selectObject: .spectralSlice
		.skewValue = Get skewness: 2
		selectObject: .skewness
		Set value at sample number: 0, .s, .skewValue
		# Kurtosis
		selectObject: .spectralSlice
		.kurtosisValue = Get kurtosis: 2
		selectObject: .kurtosis
		Set value at sample number: 0, .s, .kurtosisValue
		# cm
		selectObject: .spectralSlice
		.cmValue = Get central moment: 3, 2
		selectObject: .cm
		Set value at sample number: 0, .s, .cmValue
		
		selectObject: .spectralSlice
		.ltas = To Ltas (1-to-1)
		.report$ = Report spectral trend: 550, 5500, "Logarithmic", "Robust"
		.trend = extractNumber(.report$, "Slope:")
		selectObject: .tilt
		Set value at sample number: 0, .s, .trend

		# Clean up
		selectObject: .spectralSlice, .ltas
		Remove
	endfor

	# Clean up
	selectObject: .spectrogram
	Remove

	# MAU
	selectObject: .textGrid
	.t = tierMAU
	.numInt = Get number of intervals: .t
	.databaseFileMAU$ = targetPath$+.basename$+"_CoG"+".csv"
	writeFileLine: .databaseFileMAU$, "ID", ";", "Label",  ";", "Start", ";", "End", ";", "Duration", ";", "COGmax", ";", "COGmin", ";", "Tiltmax", ";", "Tiltmin", ";", "COGmid", ";", "Tiltmid", ";", "COGint", ";", "Tiltint", ";", "COGmean", ";", "SDmid", ";", "SDmean", ";", "Skewmid", ";", "Skewmean", ";", "Kurtmid", ";", "Kurtmean", ";", "CM3mid", ";", "CM3mean", ";", "File"

	for .i to .numInt
		.cogmax = undefined
		.cogmin = undefined
		.cogmid = undefined
		.cogInt = undefined
		.cogmean = undefined
		.tiltmax = undefined
		.tiltmin = undefined
		.tiltmid = undefined
		.tiltInt = undefined
		
		selectObject: .textGrid
		.label$ = Get label of interval: .t, .i
		if .label$ <> ""
			.start = Get start time of interval: .t, .i
			.end = Get end time of interval: .t, .i
			.duration = .end - .start
			.margin = .duration/4
			.labelText$ = replace_regex$(.label$, "__.*$", "", 0)
			.id$ = replace_regex$(.label$, "^.+__", "", 0)
			
			# Values
			selectObject: .intensity
			.tMax = Get time of maximum: .start + .margin, .end  - .margin, "Parabolic"
			
			# CoG values
			selectObject: .cog
			.cogmax = Get maximum: .start + .margin, .end  - .margin, "Parabolic"
			.cogmin = Get minimum: .start + .margin, .end  - .margin, "Parabolic"
			.cogmid = Get value at time: (.start + .end)/2, "Cubic"
			.cogInt = Get value at time: .tMax, "Cubic"
			.cogmean = Get mean: 0, .start, .end

			# SD values
			selectObject: .sd
			.sdmid = Get value at time: (.start + .end)/2, "Cubic"
			.sdmean = Get mean: 0, .start, .end
			# Skewness values
			selectObject: .skewness
			.skewmid = Get value at time: (.start + .end)/2, "Cubic"
			.skewmean = Get mean: 0, .start, .end
			# Kurtosis values
			selectObject: .kurtosis
			.kurtmid = Get value at time: (.start + .end)/2, "Cubic"
			.kurtmean = Get mean: 0, .start, .end
			# Central Moment values
			selectObject: .cm
			.cmmid = Get value at time: (.start + .end)/2, "Cubic"
			.cmmid = .cmmid**(1/3)
			.cmmean = Get mean: 0, .start, .end
			.cmmean = .cmmean**(1/3)

			selectObject: .tilt
			.tiltmax = Get maximum: .start + .margin, .end  - .margin, "Parabolic"
			.tiltmin = Get minimum: .start + .margin, .end  - .margin, "Parabolic"
			.tiltmid = Get value at time: (.start + .end)/2, "Cubic"
			.tiltInt = Get value at time: .tMax, "Cubic"
		endif
		
		appendFileLine:  .databaseFileMAU$, .id$, ";", .labelText$, ";", "'.start:3'", ";", "'.end:3'", ";", "'.duration:3'", ";", "'.cogmax:0'", ";", "'.cogmin:0'", ";", "'.tiltmax:3'", ";", "'.tiltmin:3'", ";", "'.cogmid:0'", ";", "'.tiltmid:3'", ";", "'.cogInt:0'", ";", "'.tiltInt:3'", ";", "'.cogmean:3'", ";", "'.sdmid:3'", ";", "'.sdmean:3'", ";", "'.skewmid:3'", ";", "'.skewmean:3'", ";", "'.kurtmid:3'", ";", "'.kurtmean:3'", ";", "'.cmmid:0'", ";", "'.cmmean:0'", ";", .textGridName$
		
	endfor

	selectObject: .textGrid, .audio, .intensity, .cog, .tilt, .sd, .skewness, .kurtosis, .cm
	Remove
endfor
