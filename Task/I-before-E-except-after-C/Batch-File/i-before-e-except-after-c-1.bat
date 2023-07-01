::I before E except after C task from Rosetta Code Wiki
::Batch File Implementation

@echo off
setlocal enabledelayedexpansion
	::Initialization
set ie=0
set ei=0
set cie=0
set cei=0

set propos1=FALSE
set propos2=FALSE
set propos3=FALSE

	::Do the matching
for /f %%X in (unixdict.txt) do (
	set word=%%X
	if not "!word:ie=!"=="!word!" if "!word:cie=!"=="!word!" (set /a ie+=1)
	if not "!word:ei=!"=="!word!" if "!word:cei=!"=="!word!" (set /a ei+=1)
	if not "!word:cei=!"=="!word!" (set /a cei+=1)
	if not "!word:cie=!"=="!word!" (set /a cie+=1)
)

set /a "counter1=!ei!*2,counter2=!cie!*2"

if !ie! gtr !counter1! set propos1=TRUE
echo.Plausibility of "I before E when not preceded by C": !propos1! (!ie! VS !ei!)

if !cei! gtr !counter2! set propos2=TRUE
echo.Plausibility of "E before I when preceded by C": !propos2! (!cei! VS !cie!)

if !propos1!==TRUE if !propos2!==TRUE (set propos3=TRUE)
echo.Overall plausibility of "I before E EXCEPT after C": !propos3!

pause
exit /b 0
