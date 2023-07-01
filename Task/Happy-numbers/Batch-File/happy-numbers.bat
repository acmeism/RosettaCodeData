@echo off
setlocal enableDelayedExpansion
::Define a list with 10 terms as a convenience for defining a loop
set "L10=0 1 2 3 4 5 6 7 8 9"
shift /1 & goto %1
exit /b


:list min count
:: This routine prints all happy numbers > min (arg1)
:: until it finds count (arg2) happy numbers.
set /a "n=%~1, cnt=%~2"
call :listInternal
exit /b


:test min [max]
:: This routine sequentially tests numbers between min (arg1) and max (arg2)
:: to see if they are happy. If max is not specified then it defaults to min.
set /a "min=%~1"
if "%~2" neq "" (set /a "max=%~2") else set max=%min%
::The FOR /L loop does not detect integer overflow, so must protect against
::an infinite loop when max=0x7FFFFFFFF
set end=%max%
if %end% equ 2147483647 set /a end-=1
for /l %%N in (%min% 1 %end%) do (
  call :testInternal %%N && (echo %%N is happy :^)) || echo %%N is sad :(
)
if %end% neq %max% call :testInternal %max% && (echo %max% is happy :^)) || echo %max% is sad :(
exit /b


  :listInternal
  :: This loop sequentially tests each number >= n. The loop conditionally
  :: breaks within the body once cnt happy numbers have been found, or if
  :: the max integer value is reached. Performance is improved by using a
  :: FOR loop to perform most of the looping, with a GOTO only needed once
  :: per 100 iterations.
  for %%. in (
    %L10% %L10% %L10% %L10% %L10% %L10% %L10% %L10% %L10% %L10%
  ) do (
    call :testInternal !n! && (
      echo !n!
      set /a cnt-=1
      if !cnt! leq 0 exit /b 0
    )
    if !n! equ 2147483647 (
      >&2 echo ERROR: Maximum integer value reached
      exit /b 1
    )
    set /a n+=1
  )
  goto :listInternal


  :testInternal n
  :: This routine loops until the sum of squared digits converges on 1 (happy)
  :: or it detects a cycle (sad). It exits with errorlevel 0 for happy and 1 for sad.
  :: Performance is improved by using a FOR loop for the looping instead of a GOTO.
  :: Numbers less than 1000 never neeed more than 20 iterations, and any number
  :: with 4 or more digits shrinks by at least one digit each iteration.
  :: Since Windows batch can't handle more than 10 digits, allowance for 27
  :: iterations is enough, and 30 is more than adequate.
  setlocal
  set n=%1
  for %%. in (%L10% %L10% %L10%) do (
    if !n!==1 exit /b 0
    %= Only numbers < 1000 can cycle =%
    if !n! lss 1000 (
      if defined t.!n! exit /b 1
      set t.!n!=1
    )
    %= Sum the squared digits                                          =%
    %= Batch can't handle numbers greater than 10 digits so we can use =%
    %= a constrained FOR loop and avoid a slow goto                    =%
    set sum=0
    for /l %%N in (1 1 10) do (
      if !n! gtr 0 set /a "sum+=(n%%10)*(n%%10), n/=10"
    )
    set /a n=sum
  )
