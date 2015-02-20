@echo off
setlocal ENABLEDELAYEDEXPANSION
set n=15
set /A nn=n+1
for /L %%i in (0,1,%nn%) do set t.%%i=0
set t.1=1
for /L %%i in (1,1,%n%) do (
    set /A ip=%%i+1
    for /L %%j in (%%i,-1,1) do (
        set /A jm=%%j-1
	    set /A t.%%j=t.%%j+t.!jm!
	)
    set /A t.!ip!=t.%%i	
    for /L %%j in (!ip!,-1,1) do (
        set /A jm=%%j-1
	    set /A t.%%j=t.%%j+t.!jm!
	)
    set /A ci=t.!ip!-t.%%i
	echo !ci!
  )
)
pause
