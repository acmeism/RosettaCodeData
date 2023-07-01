:: Gray Code Task from Rosetta Code
:: Batch File Implementation

@echo off
rem -------------- define batch file macros with parameters appended
rem more info: https://www.dostips.com/forum/viewtopic.php?f=3&t=2518
setlocal disabledelayedexpansion	% == required for macro ==%
(set \n=^^^
%== this creates escaped line feed for macro ==%
)

rem convert to binary (unsigned)
rem argument: natnum bitlength outputvar
rem note: if natnum is negative, then !outputvar! is empty
set tobinary=for %%# in (1 2) do if %%#==2 (  %\n%
   for /f "tokens=1,2,3" %%a in ("!args!") do (  %\n%
      set "natnum=%%a"^&set "bitlength=%%b"^&set "outputvar=%%c")  %\n%
   set "!outputvar!="  %\n%
   if !natnum! geq 0 (  %\n%
      set "currnum=!natnum!"  %\n%
      for /l %%m in (1,1,!bitlength!) do (  %\n%
         set /a "bit=!currnum!%%2"  %\n%
         for %%v in (!outputvar!) do set "!outputvar!=!bit!!%%v!"  %\n%
         set /a "currnum/=2"  %\n%
      )  %\n%
   )  %\n%
) else set args=

goto :main-thing  %== jump to the main thing ==%
rem -------------- usual "call" sections
rem the sad disadvantage of using these is that they are slow (TnT)

rem gray code encoder
rem argument: natnum outputvar
:encoder
set /a "%~2=%~1^(%~1>>1)"
goto :eof

rem gray code decoder
rem argument: natnum outputvar
:decoder
set "inp=%~1" & set "%~2=0"
:while-loop-1
if %inp% gtr 0 (
   set /a "%~2^=%inp%, inp>>=1"
   goto while-loop-1
)
goto :eof

rem -------------- main thing
:main-thing
setlocal enabledelayedexpansion
echo(# -^> bin -^> enc -^> dec
for /l %%n in (0,1,31) do (
   %tobinary% %%n 5 bin
   call :encoder "%%n" "enc"
   %tobinary% !enc! 5 gray
   call :decoder "!enc!" "dec"
   %tobinary% !dec! 5 rebin
   echo(%%n -^> !bin! -^> !gray! -^> !rebin!
)
exit /b 0
