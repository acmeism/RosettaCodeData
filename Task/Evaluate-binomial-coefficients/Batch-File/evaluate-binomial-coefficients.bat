@echo off & setlocal

if "%~2"=="" ( echo Usage: %~nx0 n k && goto :EOF )

call :binom binom %~1 %~2
1>&2 set /P "=%~1 choose %~2 = "<NUL
echo %binom%

goto :EOF

:binom <var_to_set> <N> <K>
setlocal
set /a coeff=1, nk=%~2 - %~3 + 1
for /L %%I in (%nk%, 1, %~2) do set /a coeff *= %%I
for /L %%I in (1, 1, %~3) do set /a coeff /= %%I
endlocal && set "%~1=%coeff%"
goto :EOF
