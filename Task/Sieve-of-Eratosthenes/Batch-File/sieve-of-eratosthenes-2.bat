@if defined eratosSort goto sort
@echo off
setlocal enabledelayedexpansion enableextensions
%= Input is either first argument or stdin =%
if "%~1"=="" (
  set /p n=|| goto :eof
  set /a n=n
) else (set /a n=%~1)
(
if %n% lss 2 goto help
if %n% gtr 46340 goto help
%= Guess isqrt using Newton method =%
%= Modified to remove adjustments for negative integers =%
%= www.dostips.com/forum/viewtopic.php?f=3&t=5819&start=15#p43998 =%
set /a "x=(%n%)/(11*1024)+40, x=((%n%)/x+x)>>1, x=((%n%)/x+x)>>1, x=((%n%)/x+x)>>1, x=((%n%)/x+x)>>1, x=((%n%)/x+x)>>1"
for /f "delims==" %%a in ('set . 2^>nul') do set "%%a="
set .2=1
if %n% gtr 2 set .3=1
for %%a in (5 7) do for /l %%i in (%%a,6,%n%) do set .%%i=1
for %%a in (5 7) do for /l %%i in (%%a,6,!x!) do (
  if defined .%%i (
  set /a t=%%i*%%i
  for /l %%j in (!t!,%%i,%n%) do set .%%j=
))
set eratosSort=1
for /f %%i in ('cmd /q /v:on /e:on /d /c "%~f0" ^| sort') do echo/%%i
goto :eof
)
:sort
(
%= Sort numbers =%
%= stackoverflow.com/a/32306526 =%
(for /f "delims=.=" %%i in ('set .') do (
  set "Z=    %%i"
  echo !Z:~-5!
))
goto :eof
)
:help
>&2 echo Numbers should be in range 2-46340. 46341^^2 and greater exceeds 32 bits of precision.
