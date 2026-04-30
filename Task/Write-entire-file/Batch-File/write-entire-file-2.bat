@echo off
setlocal enableextensions
type nul>%1 || goto:eof
::don't ignore blank lines
for /f tokens^=1*^ delims^=]^ eol^= %%a in ('find /n /v ""') do echo(%%b>>%1
