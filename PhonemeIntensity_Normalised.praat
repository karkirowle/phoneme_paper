
#
# Copyright: 2021, R.J.J.H. van Son and the Netherlands Cancer Institute
# License: GNU GPL v2 or later
# email: r.j.j.h.vanson@gmail.com, r.v.son@nki.nl
#
#     PhonemeIntensity_Normalised.praat: Praat script to calculate intensity in dB
# Reports values: Max, Min, Median, 5% Perc., 95% Perc., Mean, SD
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
	Scale intensity: 70
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
	
	# MAU
	selectObject: .textGrid
	.t = tierMAU
	.numInt = Get number of intervals: .t
	.databaseFileMAU$ = targetPath$+.basename$+"_Intensity"+".csv"
	writeFileLine: .databaseFileMAU$, "ID", ";", "Label",  ";", "Start", ";", "End", ";", "Duration", ";", "Max", ";", "Min", ";", "Median", ";", "Perc5", ";", "Perc95", ";", "Mean", ";", "SD", ";", "File"

	for .i to .numInt
		.min = undefined
		.max = undefined
		.median = undefined
		.quant5 = undefined
		.quant95 = undefined
		.mean = undefined
		.sd = undefined

		selectObject: .textGrid
		.label$ = Get label of interval: .t, .i
		if .label$ <> ""
			.start = Get start time of interval: .t, .i
			.end = Get end time of interval: .t, .i
			.duration = .end - .start
			.labelText$ = replace_regex$(.label$, "__.*$", "", 0)
			.id$ = replace_regex$(.label$, "^.+__", "", 0)
			
			# Min, Max, Median, 5%, 95%, Mean, SD
			selectObject: .intensity
			.max = Get maximum: .start, .end, "Parabolic"
			.min = Get minimum: .start, .end, "Parabolic"
			.median = Get quantile: .start, .end, 0.50
			.quant5 = Get quantile: .start, .end, 0.05
			.quant95 = Get quantile: .start, .end, 0.95
			.mean = Get mean: .start, .end, "energy"
			.sd = Get standard deviation: .start, .end
		endif
		
		appendFileLine:  .databaseFileMAU$, .id$, ";", .labelText$, ";", "'.start:3'", ";", "'.end:3'", ";", "'.duration:3'", ";", "'.max:3'", ";", "'.min:3'", ";", "'.median:3'", ";", "'.quant5:3'", ";", "'.quant95:3'", ";", "'.mean:3'", ";", "'.sd:3'", ";", .textGridName$
		
	endfor

	selectObject: .textGrid, .audio, .intensity
	Remove
endfor
