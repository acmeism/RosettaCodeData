@echo off
for /f "tokens=*" %%s in (%~n0%~x0) do (echo %%s)
