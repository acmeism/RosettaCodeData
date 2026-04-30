@echo off
for /f skip^=1^ eol^= %%a in ('replace /W ? . ^<con 2^>nul') do echo:%%a& goto :eof
