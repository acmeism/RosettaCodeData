# Author AlephX Aug 17 2011

SetFormat, float, 4.2
SetFormat, FloatFast, 4.2

data = %A_scriptdir%\readings.txt
result = %A_scriptdir%\results.txt
totvalid := 0
totsum := 0
totavg:= 0

Loop, Read, %data%, %result%
	{
	sum := 0
	Valid := 0
	Couples := 0
	Lines := A_Index
    Loop, parse, A_LoopReadLine, %A_Tab%
		{
        ;MsgBox, Field number %A_Index% is %A_LoopField%
		if A_index = 1
			{
			Date := A_LoopField
			Counter := 0
			}
		else
			{
			Counter++
			couples := Couples + 0.5
			if Counter = 1
				{
				value := A_LoopField / 1
				}
			else
				{
				if A_loopfield > 0
					{
					Sum := Sum + value
					Valid++
					
					if (wrong > maxwrong)
						{
						maxwrong := wrong
						lastwrongdate := currwrongdate
						startwrongdate := firstwrongdate
						startoccurrence := firstoccurrence
						lastoccurrence := curroccurrence
						}
					wrong := 0
					}
				else
					{
					wrong++
					currwrongdate := date
					curroccurrence := (A_index-1) / 2	
					if (wrong = 1)
						{
						firstwrongdate := date
						firstoccurrence := curroccurrence
						}
					}				
				Counter := 0
				}
			}			
		}
	avg := sum / valid
	TotValid := Totvalid+valid
	TotSum := Totsum+sum
	FileAppend, Day: %date% sum: %sum% avg: %avg% Readings: %valid%/%couples%`n	
	}
	
Totavg := TotSum / TotValid
FileAppend, `n`nDays %Lines%`nMaximal wrong readings: %maxwrong% from %startwrongdate% at %startoccurrence% to %lastwrongdate% at %lastoccurrence%`n`n, %result%
FileAppend, Valid readings: %TotValid%`nTotal Value: %TotSUm%`nAverage: %TotAvg%, %result%
