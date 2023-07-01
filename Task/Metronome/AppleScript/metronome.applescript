set bpm to the text returned of (display dialog "How many beats per minute?" default answer 60)
set pauseBetweenBeeps to (60 / bpm)
repeat
	beep
	delay pauseBetweenBeeps
end repeat
