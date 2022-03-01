#
# Copyright: 2021, R.J.J.H. van Son and the Netherlands Cancer Institute
# License: GNU GPL v2 or later
# email: r.j.j.h.vanson@gmail.com, r.v.son@nki.nl
#
#     PhonemeFormants.praat: Praat script to calculate formants for phonemes
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
	selectObject: .audio
	.intensity = To Intensity: 100, 0, "yes"
	selectObject: .audio
	.formants = To Formant (robust): 0, 5, 5500, 0.025, 50, 1.5, 5, 1e-06

	
	# MAU
	selectObject: .textGrid
	.t = tierMAU
	.numInt = Get number of intervals: .t
	.databaseFileMAU$ = targetPath$+.basename$+"_Formants"+".csv"
	writeFileLine: .databaseFileMAU$, "ID", ";", "Label",  ";", "Start", ";", "End", ";", "Duration", ";", "F1int", ";", "F1mid", ";", "F1max", ";", "F1min", ";", "F1median", ";", "F1mean", ";", "F1sd", ";", "F2int", ";", "F2mid", ";", "F2max", ";", "F2min", ";", "F2median", ";", "F2mean", ";", "F2sd", ";", "F3int", ";", "F3mid", ";", "F3max", ";", "F3min", ";", "F3median", ";", "F3mean", ";", "F3sd", ";", "File"

	for .i to .numInt
		.midInt = undefined
		.minInt = undefined
		.maxInt = undefined
		.medianInt = undefined
		.meanInt = undefined
		.sdInt = undefined

		.intF1 = undefined
		.midF1 = undefined
		.minF1 = undefined
		.maxF1 = undefined
		.medianF1 = undefined
		.meanF1 = undefined
		.sdF1 = undefined

		.intF2 = undefined
		.midF2 = undefined
		.minF2 = undefined
		.maxF2 = undefined
		.medianF2 = undefined
		.meanF2 = undefined
		.sdF2 = undefined

		.intF3 = undefined
		.midF3 = undefined
		.minF3 = undefined
		.maxF3 = undefined
		.medianF3 = undefined
		.meanF3 = undefined
		.sdF3 = undefined

		selectObject: .textGrid
		.label$ = Get label of interval: .t, .i
		if .label$ <> ""
			.start = Get start time of interval: .t, .i
			.end = Get end time of interval: .t, .i
			.duration = .end - .start
			.labelText$ = replace_regex$(.label$, "__.*$", "", 0)
			.id$ = replace_regex$(.label$, "^.+__", "", 0)
			
			# Time of maximum Int
			selectObject: .intensity
			.tmax = Get time of maximum: .start, .end, "Parabolic"

			selectObject: .formants
			.intF1 = Get value at time: 1, .tmax, "hertz", "Linear"
			.midF1 = Get value at time: 1, (.end + .start)/2, "hertz", "Linear"
			.minF1 = Get minimum: 1, .start, .end, "hertz", "Parabolic"
			.maxF1 = Get maximum: 1, .start, .end, "hertz", "Parabolic"
			.medianF1 = Get quantile: 1, .start, .end, "hertz", 0.5
			.meanF1 = Get mean: 1, .start, .end, "hertz"
			.sdF1 = Get standard deviation: 1, .start, .end, "hertz"

			.intF2 = Get value at time: 2, .tmax, "hertz", "Linear"
			.midF2 = Get value at time: 2, (.end + .start)/2, "hertz", "Linear"
			.minF2 = Get minimum: 2, .start, .end, "hertz", "Parabolic"
			.maxF2 = Get maximum: 2, .start, .end, "hertz", "Parabolic"
			.medianF2 = Get quantile: 2, .start, .end, "hertz", 0.5
			.meanF2 = Get mean: 2, .start, .end, "hertz"
			.sdF2 = Get standard deviation: 2, .start, .end, "hertz"

			.intF3 = Get value at time: 3, .tmax, "hertz", "Linear"
			.midF3 = Get value at time: 3, (.end + .start)/2, "hertz", "Linear"
			.minF3 = Get minimum: 3, .start, .end, "hertz", "Parabolic"
			.maxF3 = Get maximum: 3, .start, .end, "hertz", "Parabolic"
			.medianF3 = Get quantile: 3, .start, .end, "hertz", 0.5
			.meanF3 = Get mean: 3, .start, .end, "hertz"
			.sdF3 = Get standard deviation: 3, .start, .end, "hertz"

		endif
		
		appendFileLine:  .databaseFileMAU$, .id$, ";", .labelText$, ";", "'.start:3'", ";", "'.end:3'", ";", "'.duration:3'", ";", "'.intF1:0'", ";", "'.midF1:0'", ";", "'.maxF1:0'", ";", "'.minF1:0'", ";", "'.medianF1:0'", ";", "'.meanF1:0'", ";", "'.sdF1:1'", ";", "'.intF2:0'", ";", "'.midF2:0'", ";", "'.maxF2:0'", ";", "'.minF2:0'", ";", "'.medianF2:0'", ";", "'.meanF2:0'", ";", "'.sdF2:1'", ";", "'.intF3:0'", ";", "'.midF3:0'", ";", "'.maxF3:0'", ";", "'.minF3:0'", ";", "'.medianF3:0'", ";", "'.meanF3:0'", ";", "'.sdF3:1'", ";", .textGridName$
	endfor

	selectObject: .textGrid, .audio, .intensity, .formants
	Remove
endfor
