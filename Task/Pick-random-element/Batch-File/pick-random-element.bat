@echo off
setlocal enabledelayedexpansion

	::Initializing the pseudo-array...
set "pseudo=Alpha Beta Gamma Delta Epsilon"
set cnt=0 & for %%P in (!pseudo!) do (
	set /a cnt+=1
	set "pseudo[!cnt!]=%%P"
)
	::Do the random thing...
set /a rndInt=%random% %% cnt +1

	::Print the element corresponding to rndint...
echo.!pseudo[%rndInt%]!
pause
exit /b
