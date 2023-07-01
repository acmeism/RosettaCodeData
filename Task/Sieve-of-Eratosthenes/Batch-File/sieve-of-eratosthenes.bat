:: Sieve of Eratosthenes for Rosetta Code - PG
@echo off
setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS
rem echo on
set /p n=limit:
rem set n=100
for /L %%i in (1,1,%n%) do set crible.%%i=1
for /L %%i in (2,1,%n%) do (
  if !crible.%%i! EQU 1 (
    set /A w = %%i * 2
    for /L %%j in (!w!,%%i,%n%) do (
	  set crible.%%j=0
	)
  )
)
for /L %%i in (2,1,%n%) do (
  if !crible.%%i! EQU 1 echo %%i
)
pause
