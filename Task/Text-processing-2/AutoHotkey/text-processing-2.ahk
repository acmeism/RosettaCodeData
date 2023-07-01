; Author: AlephX Aug 17 2011
data = %A_scriptdir%\readings.txt

Loop, Read, %data%
	{
	Lines := A_Index	
    StringReplace, dummy, A_LoopReadLine, %A_Tab%,, All UseErrorLevel
		
    Loop, parse, A_LoopReadLine, %A_Tab%
		{
		wrong := 0
		if A_index = 1
			{
			Date := A_LoopField
			if (Date == OldDate)
				{
				WrongDates = %WrongDates%%OldDate% at %Lines%`n
				TotwrongDates++
				Wrong := 1
				break
				}
			}
		else
			{		
			if (A_loopfield/1 < 0)
				{
				Wrong := 1
				break
				}

			}
		}

	if (wrong == 1)
		totwrong++
	else
		valid++
	
	if (errorlevel <> 48)
		{
		if (wrong == 0)
			{	
			totwrong++
			valid--
			}
		unvalidformat++
		}	
		
	olddate := date
	}
	
msgbox, Duplicate Dates:`n%wrongDates%`nRead Lines: %lines%`nValid Lines: %valid%`nwrong lines: %totwrong%`nDuplicates: %TotWrongDates%`nWrong Formatted: %unvalidformat%`n
