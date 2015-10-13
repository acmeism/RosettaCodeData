@echo off
if "%~1"=="" exit /b 3
set "samp_path=%~1"
set "tst_var="

	%== Store the current directory of the CMD ==%
for /f %%T in ('cd') do set curr_dir=%%T

	%== Go to the samp_path ==%
cd %samp_path% 2>nul ||goto :folder_not_found

	%== The current directory is now samp_path ==%
	%== Scan what is inside samp_path ==%	
for /f "usebackq delims=" %%D in (
	`dir /b 2^>nul ^& dir /b /ah 2^>nul`
) do set "tst_var=1"

if "%tst_var%"=="1" (
	echo "%samp_path%" is NOT empty.
	cd %curr_dir%
	exit /b 1
) else (
	echo "%samp_path%" is empty.
	cd %curr_dir%
	exit /b 0
)

:folder_not_found
echo Folder not found.
exit /b 2
