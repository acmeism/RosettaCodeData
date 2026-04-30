@echo off
choice /M "Custom implementation?"
if errorlevel 2 goto native
goto custom

:native
md %~1
goto:eof

:custom
::pushd stack will be discarded at endlocal or EOF
setlocal
set "dirpath=%~1"
set dirpath="%dirpath:\=" "%"
::resolve \ (filesystem root) at the start
set "dirpath=%dirpath:"" "="\%"
for %%i in (%dirpath%) do (
md %%i
pushd %%i
)
goto:eof
