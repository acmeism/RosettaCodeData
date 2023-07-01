::Number Names Task from Rosetta Code Wiki
::Batch File Implementation

@echo off
setlocal enabledelayedexpansion

if "%~1"=="iterate" goto num_name

::Define the words
set "small=One Two Three Four Five Six Seven Eight Nine Ten"
set "small=%small% Eleven Twelve Thirteen Fourteen Fifteen Sixteen Seventeen Eighteen Nineteen"
set "decade=Twenty Thirty Forty Fifty Sixty Seventy Eighty Ninety"
set "big=Thousand Million Billion"

::Seperating each word...
set cnt=0
for %%X in (%small%) do (set /a "cnt+=1"&set small!cnt!=%%X)
set cnt=0
for %%Y in (%decade%) do (set decade!cnt!=%%Y&set /a "cnt+=1")
set cnt=0
for %%Z in (%big%) do (set big!cnt!=%%Z&set /a "cnt+=1")

::The Main Thing
for %%. in (42,27,1090,230000,1001100,-40309,0,123456789) do (
	set input=%%.
	if %%. lss 0 (set /a input*=-1)
	if !input! equ 0 (set TotalOut=Zero) else (
		call :num_word %%.
	)
	echo "!TotalOut!"
)
exit /b
::/The Main Thing

::The Procedure
:num_word
	set outP=
	set unit=0
	set num=!input!
:num_loop
set /a tmpLng1 = num %% 100
set /a tmpLng2 = tmpLng1 %% 10
set /a tmpNum1 = tmpLng1/10 - 2

if !tmpLng1! geq 1 if !tmpLng1! leq 19 (
	set "outP=!small%tmpLng1%! !outP!"
)
if !tmpLng1! geq 20 if !tmpLng1! leq 99 (
	if !tmpLng2! equ 0 (
		set "outP=!decade%tmpNum1%! !outP!"
	) else (
		set "outP=!decade%tmpNum1%!-!small%tmpLng2%! !outP!"
	)
)

set /a tmpLng1 = (num %% 1000)/100
if not !tmpLng1! equ 0 (
	set "outP=!small%tmpLng1%! Hundred !outP!"
)

set /a num/=1000
if !num! lss 1 goto :break_loop

set /a tmpLng1 = num %% 1000
if not !tmpLng1! equ 0 (
	set "outP=!big%unit%! !outP!"
)
set /a unit+=1
goto :num_loop

:break_loop
set "TotalOut=!outP!"
if %1 lss 0 set "TotalOut=Negative !outP!"

set TotalOut=%TotalOut:~0,-1%
goto :EOF
