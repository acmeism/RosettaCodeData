:: Stable Marriage Problem in Rosetta Code
:: Batch File Implementation

@echo off
setlocal enabledelayedexpansion

:: Initialization (Index Starts in 0)
set "male=abe bob col dan ed fred gav hal ian jon"
set "femm=abi bea cath dee eve fay gay hope ivy jan"

set "abe[]=abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay"
set "bob[]=cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay"
set "col[]=hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan"
set "dan[]=ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi"
set "ed[]=jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay"
set "fred[]=bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay"
set "gav[]=gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay"
set "hal[]=abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee"
set "ian[]=hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve"
set "jon[]=abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope"

set "abi[]=bob, fred, jon, gav, ian, abe, dan, ed, col, hal"
set "bea[]=bob, abe, col, fred, gav, dan, ian, ed, jon, hal"
set "cath[]=fred, bob, ed, gav, hal, col, ian, abe, dan, jon"
set "dee[]=fred, jon, col, abe, ian, hal, gav, dan, bob, ed"
set "eve[]=jon, hal, fred, dan, abe, gav, col, ed, ian, bob"
set "fay[]=bob, abe, ed, ian, jon, dan, fred, gav, col, hal"
set "gay[]=jon, gav, hal, fred, bob, abe, col, ed, dan, ian"
set "hope[]=gav, jon, bob, abe, ian, dan, hal, ed, col, fred"
set "ivy[]=ian, col, hal, gav, fred, bob, abe, ed, jon, dan"
set "jan[]=ed, hal, gav, abe, bob, jon, col, ian, fred, dan"

rem variable notation:
rem    <boy>{<index>} = <girl>
rem    <boy>[<girl>] = <index>
for %%M in (%male%) do (
   set cnt=0
   for %%. in (!%%M[]!) do (
      set "%%M{!cnt!}=%%."
      set "%%M[%%.]=!cnt!"
      set /a cnt+=1
   )
)
for %%F in (%femm%) do (
   set cnt=0
   for %%. in (!%%F[]!) do (
      set "%%F[%%.]=!cnt!"
      set /a cnt+=1
   )
)

:: The Main Thing
echo(HISTORY:
call :stableMatching
echo(
echo(NEWLYWEDS:
call :display
echo(
call :isStable
echo(
echo(What if ed and hal swapped?
call :swapper ed hal
echo(
echo(NEW-NEWLYWEDS:
call :display
echo(
call :isStable
pause>nul
exit /b 0

:: The Algorithm
:stableMatching
set "free_men=%male%"
set "free_fem=%femm%"
for %%M in (%male%) do set "%%M_tried=0"

:match_loop
if "%free_men%"=="" goto :EOF
for /f "tokens=1* delims= " %%m in ("%free_men%") do (
   rem get woman not yet proposed to, but if man's tries exceeds the number
   rem of women (poor guy), he starts again to his most preferred woman (#0).
   for /f %%x in ("!%%m_tried!") do if not defined %%m{%%x} (
      set "%%m_tried=0" & set "w=!%%m{0}!"
   ) else set "w=!%%m{%%x}!"
   set "m=%%m"

   for /f %%x in ("free_fem:!w!=") do (
      if not "!free_fem!"=="!%%x!" (
         rem accept because !w! (the woman) is free
         set "!m!_=!w!" & set "!w!_=!m!"
         set "free_men=%%n" & set "free_fem=!%%x!"
         echo(    !w! ACCEPTED !m!.
      ) else (
         rem here, !w! already has a pair; get his name and rank.
         for /f %%. in ("!w!") do set "cur_man=!%%._!"
         for /f %%. in ("!w![!cur_man!]") do set "rank_cur=!%%.!"
         rem also, get the rank of current proposing man.
         for /f %%. in ("!w![!m!]") do set "rank_new=!%%.!"

         if !rank_new! lss !rank_cur! (
            rem here, !w! will leave her pair, and choose !m!.
            set "free_men=%%n !cur_man!"
            echo(    !w! LEFT !cur_man!.
            rem pair them up now!
            set "!m!_=!w!" & set "!w!_=!m!"
            echo(    !w! ACCEPTED !m!.
         )
      )
   )
   set /a "!m!_tried+=1"
)
goto :match_loop

:: Output the Couples
:display
for %%S in (%femm%) do echo.    %%S and !%%S_!.
goto :EOF

:: Stability Checking
:isStable
for %%f in (%femm%) do (
   for %%g in (%male%) do (
      for /f %%. in ("%%f[!%%f_!]") do set "girl_cur=!%%.!"
      set "girl_aboy=!%%f[%%g]!"
      for /f %%. in ("%%g[!%%g_!]") do set "boy_cur=!%%.!"
      set "boy_agirl=!%%g[%%f]!"

      if !boy_cur! gtr !boy_agirl! (
         if !girl_cur! gtr !girl_aboy! (
            echo(STABILITY = FALSE.
            echo(%%f and %%g would rather be together than their current partners.
            goto :EOF
         )
      )
   )
)
echo(STABILITY = TRUE.
goto :EOF

:: Swapper
:swapper
set %~1.tmp=!%~1_!
set %~2.tmp=!%~2_!
set "%~1_=!%~2.tmp!"
set "%~2_=!%~1.tmp!"
set "!%~1.tmp!_=%~2"
set "!%~2.tmp!_=%~1"
goto :EOF
