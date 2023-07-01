@echo off
setlocal enableDelayedExpansion
set /a Atrue=Afalse=Btrue=Bfalse=0
for /f "tokens=3*" %%A in ('findstr /i "[^c]ie" 1_2_all_freq.txt') do if "%%B" equ "" set /a Atrue+=%%A
for /f "tokens=3*" %%A in ('findstr /i "[^c]ei" 1_2_all_freq.txt') do if "%%B" equ "" set /a Afalse+=%%A
for /f "tokens=3*" %%A in ('findstr /i "[c]ei" 1_2_all_freq.txt') do if "%%B" equ "" set /a Btrue+=%%A
for /f "tokens=3*" %%A in ('findstr /i "[c]ie" 1_2_all_freq.txt') do if "%%B" equ "" set /a Bfalse+=%%A
set /a "Aresult=Atrue/Afalse/2, Bresult=Btrue/Bfalse/2, Result=^!^!Aresult*Bresult"
set "Answer1=Plausible" & set "Answer0=Implausible"
echo I before E when not preceded by C: True=%Atrue% False=%Afalse% : !Answer%Aresult%!
echo E before I when preceded by C: True=%Btrue% False=%Bfalse% : !Answer%Bresult%!
echo I before E, except after C : !Answer%Result%!
