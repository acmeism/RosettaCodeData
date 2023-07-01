@echo off
goto Parse

 Discordian Date Converter:

 Usage:
	ddate
	ddate /v
	ddate /d isoDate
	ddate /v /d isoDate

:Parse
	shift
	if "%0"==""   goto Prologue
	if "%0"=="/v" set Verbose=1
	if "%0"=="/d" set dateToTest=%1
	if "%0"=="/d" shift
goto Parse

:Prologue
	if "%dateToTest%"=="" set dateToTest=%date%
	for %%a in (GYear GMonth GDay GMonthName GWeekday GDayThisYear) do set %%a=fnord
	for %%a in (DYear DMonth DDay DMonthName DWeekday) do set %%a=MUNG
goto Start

:Start
	for /f "tokens=1,2,3 delims=/:;-. " %%a in ('echo %dateToTest%') do (
		set GYear=%%a
		set GMonth=%%b
		set GDay=%%c
	)
goto GMonthName

:GMonthName
	if %GMonth% EQU  1	set GMonthName=January
	if %GMonth% EQU  2	set GMonthName=February
	if %GMonth% EQU  3	set GMonthName=March
	if %GMonth% EQU  4	set GMonthName=April
	if %GMonth% EQU  5	set GMonthName=May
	if %GMonth% EQU  6	set GMonthName=June
	if %GMonth% EQU  7	set GMonthName=July
	if %GMonth% EQU  8	set GMonthName=August
	if %GMonth% EQU  9	set GMonthName=September
	if %GMonth% EQU 10	set GMonthName=October
	if %GMonth% EQU 11	set GMonthName=November
	if %GMonth% EQU 12	set GMonthName=December
goto GLeap

:GLeap
	set /a CommonYear=GYear %% 4
	set /a CommonCent=GYear %% 100
	set /a CommonQuad=GYear %% 400
	set GLeap=0
	if %CommonYear% EQU 0 set GLeap=1
	if %CommonCent% EQU 0 set GLeap=0
	if %CommonQuad% EQU 0 set GLeap=1
goto GDayThisYear

:GDayThisYear
	set GDayThisYear=%GDay%
	if %GMonth% GTR 11                  set /a GDayThisYear=%GDayThisYear%+30
	if %GMonth% GTR 10                  set /a GDayThisYear=%GDayThisYear%+31
	if %GMonth% GTR  9                  set /a GDayThisYear=%GDayThisYear%+30
	if %GMonth% GTR  8                  set /a GDayThisYear=%GDayThisYear%+31
	if %GMonth% GTR  7                  set /a GDayThisYear=%GDayThisYear%+31
	if %GMonth% GTR  6                  set /a GDayThisYear=%GDayThisYear%+30
	if %GMonth% GTR  5                  set /a GDayThisYear=%GDayThisYear%+31
	if %GMonth% GTR  4                  set /a GDayThisYear=%GDayThisYear%+30
	if %GMonth% GTR  3                  set /a GDayThisYear=%GDayThisYear%+31
	if %GMonth% GTR  2 if %GLeap% EQU 1 set /a GDayThisYear=%GDayThisYear%+29
	if %GMonth% GTR  2 if %GLeap% EQU 0 set /a GDayThisYear=%GDayThisYear%+28
	if %GMonth% GTR  1                  set /a GDayThisYear=%GDayThisYear%+31
goto DYear

:DYear
	set /a DYear=GYear+1166
goto DMonth

:DMonth
	set DMonth=1
	set DDay=%GDayThisYear%
	if %DDay% GTR 73 (
		set /a DDay=%DDay%-73
		set /a DMonth=%DMonth%+1
	)
	if %DDay% GTR 73 (
		set /a DDay=%DDay%-73
		set /a DMonth=%DMonth%+1
	)
	if %DDay% GTR 73 (
		set /a DDay=%DDay%-73
		set /a DMonth=%DMonth%+1
	)
	if %DDay% GTR 73 (
		set /a DDay=%DDay%-73
		set /a DMonth=%DMonth%+1
	)
goto DDay

:DDay
	if %GLeap% EQU 1 (
		if %GDayThisYear% GEQ 61 (
			set /a DDay=%DDay%-1
		)
	)
	if %DDay% EQU 0 (
		set /a DDay=73
		set /a DMonth=%DMonth%-1
	)
goto DMonthName

:DMonthName
	if %DMonth% EQU 1 set DMonthName=Chaos
	if %DMonth% EQU 2 set DMonthName=Discord
	if %DMonth% EQU 3 set DMonthName=Confusion
	if %DMonth% EQU 4 set DMonthName=Bureaucracy
	if %DMonth% EQU 5 set DMonthName=Aftermath
goto DTib

:DTib
	set DTib=0
	if %GDayThisYear% EQU 60 if %GLeap% EQU 1 set DTib=1
	if %GLeap% EQU 1 if %GDayThisYear% GTR 60 set /a GDayThisYear=%GDayThisYear%-1
	set DWeekday=%GDayThisYear%
goto DWeekday

:DWeekday
	if %DWeekday% LEQ 5 goto _DWeekday
	set /a DWeekday=%DWeekday%-5
	goto DWeekday
:_DWeekday
	if %DWeekday% EQU 1 set DWeekday=Sweetmorn
	if %DWeekday% EQU 2 set DWeekday=Boomtime
	if %DWeekday% EQU 3 set DWeekday=Pungenday
	if %DWeekday% EQU 4 set DWeekday=Prickle-Prickle
	if %DWeekday% EQU 5 set DWeekday=Setting Orange
goto GWeekday

:GWeekday
goto GEnding

:GEnding
	set GEnding=th
	for %%a in (1 21 31) do	if %GDay% EQU %%a set GEnding=st
	for %%a in (2 22) do 	if %GDay% EQU %%a set GEnding=nd
	for %%a in (3 23) do	if %GDay% EQU %%a set GEnding=rd
goto DEnding

:DEnding
	set DEnding=th
	for %%a in (1 21 31 41 51 61 71) do if %Dday% EQU %%a set DEnding=st
	for %%a in (2 22 32 42 52 62 72) do if %Dday% EQU %%a set DEnding=nd
	for %%a in (3 23 33 43 53 63 73) do if %Dday% EQU %%a set DEnding=rd
goto Display

:Display
	if "%Verbose%"=="1" goto Display2
	echo.
	if %DTib% EQU 1 (
		echo St. Tib's Day, %DYear%
	) else echo %DWeekday%, %DMonthName% %DDay%%DEnding%, %DYear%
goto Epilogue

:Display2
	echo.
	echo  Gregorian: %GMonthName% %GDay%%GEnding%, %GYear%
	if %DTib% EQU 1 (
		echo Discordian: St. Tib's Day, %DYear%
	) else echo Discordian: %DWeekday%, %DMonthName% %DDay%%DEnding%, %DYear%
goto Epilogue

:Epilogue
set Verbose=
set dateToTest=
echo.

:End
