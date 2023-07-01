@echo off
setlocal enableDelayedExpansion
for /f %%A in ('findstr /i "^ie [^c]ie" unixdict.txt ^| find /c /v ""') do set Atrue=%%A
for /f %%A in ('findstr /i "^ei [^c]ei" unixdict.txt ^| find /c /v ""') do set Afalse=%%A
for /f %%A in ('findstr /i "[c]ei" unixdict.txt ^| find /c /v ""') do set Btrue=%%A
for /f %%A in ('findstr /i "[c]ie" unixdict.txt ^| find /c /v ""') do set Bfalse=%%A
set /a "Aresult=Atrue/Afalse/2, Bresult=Btrue/Bfalse/2, Result=^!^!Aresult*Bresult"
set "Answer1=Plausible" & set "Answer0=Implausible"
echo I before E when not preceded by C: True=%Atrue% False=%Afalse% : !Answer%Aresult%!
echo E before I when preceded by C: True=%Btrue% False=%Bfalse% : !Answer%Bresult%!
echo I before E, except after C : !Answer%Result%!
