@echo off
setlocal enabledelayedexpansion

call:commonpath /home/user1/tmp/coverage/test /home/user1/tmp/covert/operator /home/user1/tmp/coven/members
pause>nul
exit /b

:commonpath
setlocal enabledelayedexpansion

for %%i in (%*) do (
  set /a args+=1
  set arg!args!=%%i
  set fullarg!args!=%%i
)
for /l %%i in (1,1,%args%) do set fullarg%%i=!fullarg%%i:/= !

for /l %%i in (1,1,%args%) do (
  set tempcount=0
  for %%j in (!fullarg%%i!) do (
    set /a tempcount+=1
    set arg%%it!tempcount!=%%j
    set arg%%itokencount=!tempcount!
  )
)

set mintokencount=%arg1tokencount%
set leasttokens=1
for /l %%i in (1,1,%args%) do (
  set currenttokencount=!arg%%itokencount!
  if !currenttokencount! lss !mintokencount! (
    set mintokencount=!currenttokencount!
    set leasttokens=%%i
  )
)

for /l %%i in (1,1,%mintokencount%) do set commonpath%%i=!arg%leasttokens%t%%i!

for /l %%i in (1,1,%mintokencount%) do (
  for /l %%j in (1,1,%args%) do (
    set currentpath=!arg%%jt%%i!
    if !currentpath!==!commonpath%%i! set pathtokens%%j=%%i
  )
)

set minpathtokens=%pathtokens1%
set leastpathtokens=1
for /l %%i in (1,1,%args%) do (
  set currentpathtokencount=!pathtokens%%i!
  if !currentpathtokencount! lss !minpathtokens! (
    set minpathtokencount=!currentpathtokencount!
    set leastpathtokens=%%i
  )
)

set commonpath=/
for /l %%i in (1,1,!pathtokens%leastpathtokens%!) do set commonpath=!commonpath!!arg%leastpathtokens%t%%i!/
echo %commonpath%

endlocal
exit /b
