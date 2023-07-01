@echo off
setlocal enableDelayedExpansion

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FIFO queue usage

:: Define the queue
call :newQueue myQ

:: Populate the queue
for %%A in (value1 value2 value3) do call :enqueue myQ %%A

:: Test if queue is empty by examining the tail "attribute"
if myQ.tail==0 (echo myQ is empty) else (echo myQ is NOT empty)

:: Peek at the head of the queue
call:peekQueue myQ val && echo a peek at the head of myQueue shows !val!

:: Process the first queue value
call :dequeue myQ val && echo dequeued myQ value=!val!

:: Add some more values to the queue
for %%A in (value4 value5 value6) do call :enqueue myQ %%A

:: Process the remainder of the queue
:processQueue
call :dequeue myQ val || goto :queueEmpty
echo dequeued myQ value=!val!
goto :processQueue
:queueEmpty

:: Test if queue is empty using the empty "method"/"macro". Use of the
:: second IF statement serves to demonstrate the negation of the empty
:: "method". A single IF could have been used with an ELSE clause instead.
if %myQ.empty% echo myQ is empty
if not %myQ.empty% echo myQ is NOT empty
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: FIFO queue definition

:newQueue qName
set /a %~1.head=1, %~1.tail=0
:: Define an empty "method" for this queue as a sort of macro
set "%~1.empty=^!%~1.tail^! == 0"
exit /b

:enqueue qName value
set /a %~1.tail+=1
set %~1.!%~1.tail!=%2
exit /b

:dequeue qName returnVar
:: Sets errorlevel to 0 if success
:: Sets errorlevel to 1 if failure because queue was empty
if !%~1.tail! equ 0 exit /b 1
for %%N in (!%~1.head!) do (
  set %~2=!%~1.%%N!
  set %~1.%%N=
)
if !%~1.head! == !%~1.tail! (set /a "%~1.head=1, %~1.tail=0") else set /a %~1.head+=1
exit /b 0

:peekQueue qName returnVar
:: Sets errorlevel to 0 if success
:: Sets errorlevel to 1 if failure because queue was empty
if !%~1.tail! equ 0 exit /b 1
for %%N in (!%~1.head!) do set %~2=!%~1.%%N!
exit /b 0
