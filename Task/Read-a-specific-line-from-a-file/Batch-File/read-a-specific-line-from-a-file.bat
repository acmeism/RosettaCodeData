@echo off

for /f "skip=6 tokens=*" %%i in (file.txt) do (
  set line7=%%i
  goto break
)
:break
echo Line 7 is: %line7%
pause>nul
