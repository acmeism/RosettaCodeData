@echo off

for /l %%i in (1,1,10000) do call one_of_n
:: To show progress add to the FOR loop code block -
:: title %%i

for /l %%i in (1,1,10) do (
	for /f "usebackq tokens=1,2 delims=:" %%j in (`find /c "%%i" output.txt`) do echo Line %%i =%%k
)
del output.txt
pause>nul
