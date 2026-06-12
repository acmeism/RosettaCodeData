@echo off
setlocal
pushd %~dp0
:: even number of quotes to avoid termination
for /f "tokens=*" %%a in ('findstr /rc:"^\"" "%~f0') do call pig.bat %%a
goto :eof
"123456!"
"Stop! In the name of Wuv!"
"My word!"
"ESA JAXA NASA"
"this is 'quoted'"
"MgClBr (Na,K)AlSiO4"
"pig  latin"
"rosetta  code"
"the quick brown fox jumps over the lazy dog"
"by the way"
"ytterbium"
"banana"
"BaNaNa"
"bAnAnA"
"BANANA"
"pig"
"black"
"a"
"open"
"hello world"
"Hello, World!"
"o'hare O'HARE o'hare don't"
