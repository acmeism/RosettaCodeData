@echo off

call:wordCount 1 2 3 4 5 6 7 8 9 10 42 101

pause>nul
exit

:wordCount
setlocal enabledelayedexpansion

set word=100000
set line=0
for /f "delims=" %%i in (input.txt) do (
	set /a line+=1
	for %%j in (%%i) do (
		if not !skip%%j!==true (
			echo line !line! ^| word !word:~-5! - "%%~j"
			
			type input.txt | find /i /c "%%~j" > count.tmp
			set /p tmpvar=<count.tmp
			
			set tmpvar=000000000!tmpvar!
			set tmpvar=!tmpvar:~-10!
			set count[!word!]=!tmpvar! %%~j
			
			set "skip%%j=true"
			set /a word+=1
		)
	)
)
del count.tmp

set wordcount=0
for /f "tokens=1,2 delims= " %%i in ('set count ^| sort /+14 /r') do (
	set /a wordcount+=1
	for /f "tokens=2 delims==" %%k in ("%%i") do (
		set word[!wordcount!]=!wordcount!. %%j - %%k
	)
)

cls
for %%i in (%*) do echo !word[%%i]!
endlocal
goto:eof
	
