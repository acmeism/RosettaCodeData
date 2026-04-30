@echo off
setlocal enableDelayedExpansion

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: LIFO stack usage

:: Define the stack
call :newStack myStack

:: Push some values onto the stack
for %%A in (value1 value2 value3) do call :pushStack myStack %%A

:: Test if stack is empty by examining the top "attribute"
if myStack.top==0 (echo myStack is empty) else (echo myStack is NOT empty)

:: Peek at the top stack value
call:peekStack myStack val && echo a peek at the top of myStack shows !val!

:: Pop the top stack value
call :popStack myStack val && echo popped myStack value=!val!

:: Push some more values onto the stack
for %%A in (value4 value5 value6) do call :pushStack myStack %%A

:: Process the remainder of the stack
:processStack
call :popStack myStack val || goto :stackEmpty
echo popped myStack value=!val!
goto :processStack
:stackEmpty

:: Test if stack is empty using the empty "method"/"macro". Use of the
:: second IF statement serves to demonstrate the negation of the empty
:: "method". A single IF could have been used with an ELSE clause instead.
if %myStack.empty% echo myStack is empty
if not %myStack.empty% echo myStack is NOT empty
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: LIFO stack definition

:newStack stackName
set /a %~1.top=0
:: Define an empty "method" for this stack as a sort of macro
set "%~1.empty=^!%~1.top^! == 0"
exit /b

:pushStack stackName value
set /a %~1.top+=1
set %~1.!%~1.top!=%2
exit /b

:popStack stackName returnVar
:: Sets errorlevel to 0 if success
:: Sets errorlevel to 1 if failure because stack was empty
if !%~1.top! equ 0 exit /b 1
for %%N in (!%~1.top!) do (
  set %~2=!%~1.%%N!
  set %~1.%%N=
)
set /a %~1.top-=1
exit /b 0

:peekStack stackName returnVar
:: Sets errorlevel to 0 if success
:: Sets errorlevel to 1 if failure because stack was empty
if !%~1.top! equ 0 exit /b 1
for %%N in (!%~1.top!) do set %~2=!%~1.%%N!
exit /b 0
