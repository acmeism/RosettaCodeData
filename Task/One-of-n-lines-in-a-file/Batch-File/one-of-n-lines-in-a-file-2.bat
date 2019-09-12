setlocal enabledelayedexpansion

set /a count=1

for /f "tokens=*" %%i in (file.txt) do (
	set /a rand=!random! %% !count!
	if !rand!==0 set line=!count!
	set /a count+=1
)
echo %line% >> output.txt

endlocal
exit /b
