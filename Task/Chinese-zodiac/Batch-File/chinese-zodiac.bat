@echo off
setlocal enableextensions enabledelayedexpansion
if defined _canchi_main goto main
(
for /f "tokens=2 delims=:." %%g in ('chcp') do set codepage=%%g
chcp 65001 >nul
set _canchi_main=1
:: ctrl-c will return control to the parent process
cmd /c "%~f0" %~1
chcp !codepage! >nul
timeout /t 5 >nul
exit /b
)
:main
set n=%1
if [%1]==[] set /p n=
set /a "n=n, canidx=n%%10, chiidx=n%%12"

call :tabulate element "Metal Water Wood Fire Earth"
call :tabulate chi "Monkey Rooster Dog Pig Rat Ox Tiger Rabbit Dragon Snake Horse Goat"
set /a "idx=n%%10>>1"
set english=!element.%idx%! !chi.%chiidx%!

call :tabulate can "庚 辛 壬 癸 甲 乙 丙 丁 戊 己"
call :tabulate chi "申 酉 戌 亥 子 丑 寅 卯 辰 巳 午 未"
set chinese=!can.%canidx%!!chi.%chiidx%!

call :tabulate can "gēng xīn rén guǐ jiǎ yǐ bǐng dīng wù jǐ"
call :tabulate chi "shēn yǒu xū hài zǐ chǒu yín mǎo chén sì wǔ wèi"
set yinyang.0=yang
set yinyang.1=yin
set /a "ciclo=((n + 56) %% 60) + 1, idx=n&1"

echo %english% %chinese% (!can.%canidx%!-!chi.%chiidx%!) (%ciclo%/60) (!yinyang.%idx%!)
goto:eof

:tabulate
set /a idx=0
for %%i in (%~2) do (
  set %1.!idx!=%%i
  set /a idx+=1
)
