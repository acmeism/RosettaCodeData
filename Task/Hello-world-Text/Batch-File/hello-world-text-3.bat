@echo off
setlocal enableextensions
call :char 72
call :char 101
call :char 108
call :char 108
call :char 111
call :space
call :char 119
call :char 111
call :char 114
call :char 108
call :char 100
call :char 33
exit /b 0

:space
:: https://stackoverflow.com/a/9865960
:: https://stackoverflow.com/a/31396993
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do <nul set /p=".%%A "
goto :eof

:char
cmd /c exit %1
<nul set /p=%=ExitCodeAscii%
goto :eof
