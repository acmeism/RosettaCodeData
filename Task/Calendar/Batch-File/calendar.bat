::Calender Task from Rosetta Code Wiki
::Batch File Implementation

@echo off
setlocal enabledelayedexpansion

	%== Set a valid year [will not be validated] ==%
set y=1969

	%== Set the variables for months (feb_l=the normal 28 days) ==%
set jan_l=31&set apr_l=30
set mar_l=31&set jun_l=30
set may_l=31&set sep_l=30
set jul_l=31&set nov_l=30
set aug_l=31&set feb_l=28
set oct_l=31
set dec_l=31

	%== Compute day for first day of the year ==%
set /a d=(y/4+y)-(y/100-y/400)

	%== Check if that year is a leap year ==%
set /a "op1=y%%4","op2=y%%100","op3=y%%400"
if not "%op1%"=="0" (goto :no_leap)
if not "%op2%"=="0" (goto :yes_leap)
if not "%op3%"=="0" (goto :no_leap)
	:yes_leap
		%== Ooops... Leap year. Change feb_l to 29. ==%
		set feb_l=29
		set/a d-=1
	:no_leap

	%== Compute weekday of the first day... ==%
set /a d%%=7

	%== Generate everything that's inside the calendar ==%
for %%a in (jan feb mar apr may jun jul aug sep oct nov dec) do (
	set %%a=
	set chars_added=0
	for /l %%b in (1,1,!d!) do (set "%%a=!%%a!   "&set /a chars_added+=3)
	for /l %%c in (1,1,!%%a_l!) do (
		if %%c lss 10 (set "%%a=!%%a! %%c ") else (set "%%a=!%%a!%%c ")
		set /a chars_added+=3
	)
	for /l %%d in (!chars_added!,1,124) do set "%%a=!%%a! "
	set /a d=^(d+%%a_l^)%%7
)

	%== Display the calendar ==%
cls
echo.
echo.                              [SNOOPY]
echo.
echo. YEAR = %y%
echo.
echo.       January                February                March
echo. Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
echo. %jan:~0,20%   %feb:~0,20%   %mar:~0,20%
echo. %jan:~21,20%   %feb:~21,20%   %mar:~21,20%
echo. %jan:~42,20%   %feb:~42,20%   %mar:~42,20%
echo. %jan:~63,20%   %feb:~63,20%   %mar:~63,20%
echo. %jan:~84,20%   %feb:~84,20%   %mar:~84,20%
echo. %jan:~105%   %feb:~105%   %mar:~105%
echo.
echo.        April                   May                    June
echo. Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
echo. %apr:~0,20%   %may:~0,20%   %jun:~0,20%
echo. %apr:~21,20%   %may:~21,20%   %jun:~21,20%
echo. %apr:~42,20%   %may:~42,20%   %jun:~42,20%
echo. %apr:~63,20%   %may:~63,20%   %jun:~63,20%
echo. %apr:~84,20%   %may:~84,20%   %jun:~84,20%
echo. %apr:~105%   %may:~105%   %jun:~105%
echo.
echo.         July                  August                September
echo. Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
echo. %jul:~0,20%   %aug:~0,20%   %sep:~0,20%
echo. %jul:~21,20%   %aug:~21,20%   %sep:~21,20%
echo. %jul:~42,20%   %aug:~42,20%   %sep:~42,20%
echo. %jul:~63,20%   %aug:~63,20%   %sep:~63,20%
echo. %jul:~84,20%   %aug:~84,20%   %sep:~84,20%
echo. %jul:~105%   %aug:~105%   %sep:~105%
echo.
echo.       October                November               December
echo. Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
echo. %oct:~0,20%   %nov:~0,20%   %dec:~0,20%
echo. %oct:~21,20%   %nov:~21,20%   %dec:~21,20%
echo. %oct:~42,20%   %nov:~42,20%   %dec:~42,20%
echo. %oct:~63,20%   %nov:~63,20%   %dec:~63,20%
echo. %oct:~84,20%   %nov:~84,20%   %dec:~84,20%
echo. %oct:~105%   %nov:~105%   %dec:~105%
echo.
pause
endlocal
