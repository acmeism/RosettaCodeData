@echo off
setlocal enabledelayedexpansion

:: Takes file input as param #1
set "filePath=%~1"
set "fileName=%~xn1"

:: Save file contents of original file to array line[n]
set i=0
for /f "usebackq delims=" %%a in ("%filePath%") do (
	set /a i+=1
	set "line[!i!]=%%a"
)

:: Rename original file with .backup extension
ren "%filePath%" "%fileName%.backup"

:: Rewrite a new file with the name of the original
echo !line[1]!>"%filePath%"
for /l %%i in (2,1,%i%) do echo !line[%%i]!>>"%filePath%"
