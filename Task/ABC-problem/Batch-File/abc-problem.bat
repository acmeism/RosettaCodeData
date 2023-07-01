@echo off
::abc.bat
::
::Batch file to evaluate if a given string can be represented with a set of
::20 2-faced blocks.
::

::Check if a string was provided
if "%1"=="" goto ERROR

::Define blocks. Separate blocks by ':', and terminat with '::'
set "FACES=BO:XK:DQ:CP:NA:GT:RE:TG:QD:FS:JW:HU:VI:AN:OB:ER:FS:LY:PC:ZM::"
set INPUT=%1
set "COUNTER=0"

::The main loop steps through the input string, checking if an available
::block exists for each character
:LOOP_MAIN

  ::Get character, increase counter, and test if there are still characters
  call set "char=%%INPUT:~%COUNTER%,1%%"
  set /a "COUNTER+=1"
  if "%CHAR%"=="" goto LOOP_MAIN_END

  set "OFFSET=0"
  :LOOP_2

    ::Read in two characters (one block)
    call set "BLOCK=%%FACES%:~%OFFSET%,2%%"

    ::Test if the all blocks were checked. If so, no match was found
    if "%BLOCK%"==":" goto FAIL

    ::Test if current input string character is in the current block
    if /i "%BLOCK:~0,1%"=="%CHAR%" goto FOUND
    if /i "%BLOCK:~1,1%"=="%CHAR%" goto FOUND

    ::Increase offset to point to the next block
    set /a "OFFSET+=3"

  goto LOOP_2
  :LOOP_2_END

  ::If found, blank out the block used
  :FOUND
  call set "FACES=%%FACES:%BLOCK%:=  :%%"

goto LOOP_MAIN
:LOOP_MAIN_END

echo %0: It is possible to write the '%INPUT%' with my blocks.
goto END

:FAIL
echo %0: It is NOT possible to write the '%INPUT%' with my blocks.
goto END

:ERROR
echo %0: Please enter a string to evaluate
echo.

:END
