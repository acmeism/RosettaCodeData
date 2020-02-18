:: Draw a Sphere Task from Rosetta Code
:: Batch File Implementation

@echo off
rem -------------- define arithmetic "functions"
rem more info: https://www.dostips.com/forum/viewtopic.php?f=3&t=6744

rem integer sqrt arithmetic function by Aacini and penpen
rem source: https://www.dostips.com/forum/viewtopic.php?f=3&t=5819&start=30#p44016
set "sqrt(N)=( M=(N),j=M/(11*1024)+40, j=(M/j+j)>>1, j=(M/j+j)>>1, j=(M/j+j)>>1, j=(M/j+j)>>1, j=(M/j+j)>>1, j+=(M-j*j)>>31 )"

rem -------------- define batch file macros with parameters appended
rem more info: https://www.dostips.com/forum/viewtopic.php?f=3&t=2518
setlocal disabledelayedexpansion	% == required for macro ==%
(set \n=^^^
%== this creates escaped line feed for macro ==%
)

rem normalize macro
rem argument: v
set normalize=for %%# in (1 2) do if %%#==2 (  %\n%
   for /f "tokens=1" %%a in ("!args!") do set "v=%%a"  %\n%
   set /a "length_sqrd=!v![0]*!v![0]+!v![1]*!v![1]+!v![2]*!v![2]"  %\n%
   set /a "length=%sqrt(N):N=!length_sqrd!%"  %== sqrt(N) applied ==%  %\n%
   set /a "!v![0]*=100", "!v![1]*=100", "!v![2]*=100"  %== normalized elements mult. by 100 ==%  %\n%
   set /a "!v![0]/=length", "!v![1]/=length", "!v![2]/=length"  %\n%
) else set args=

rem dot macro
rem arguments: s t outputvar
set dot=for %%# in (1 2) do if %%#==2 (  %\n%
   for /f "tokens=1,2,3" %%a in ("!args!") do (  %\n%
      set "s=%%a"  %\n%
      set "t=%%b"  %\n%
      set "outputvar=%%c"  %\n%
   )  %\n%
   set /a "d=!s![0]*!t![0]+!s![1]*!t![1]+!s![2]*!t![2]"  %\n%
   if !d! lss 0 (set /a "!outputvar!=-d") else (set "!outputvar!=0")  %\n%
) else set args=

rem -------------- define pseudo-arrays
set "shades[0]=."
set "shades[1]=:"
set "shades[2]=!"
set "shades[3]=*"
set "shades[4]=o"
set "shades[5]=e"
set "shades[6]=&"
set "shades[7]=#"
set "shades[8]=%%"
set "shades[9]=@"
set "num_shades=9"  %== start at 0 ==%

set "light[0]=30" & set "light[1]=30" & set "light[2]=-50"

rem -------------- main thing: execute drawSphere
setlocal enabledelayedexpansion
%normalize% light  %== normalize macro applied ==%
rem note: due to scale up 100x of variables for calculations,
rem k=4 is the maximum value for k that does not cause overflow.
call :drawSphere 20 4 1
exit /b 0

rem -------------- the function to draw the sphere
rem arguments: R k ambient
:drawSphere
rem initialize variables from arguments
set /a "R=%1", "negR=-R", "twiceR=R*2", "twiceNegR=negR*2"
set /a "sqrdR=R*R*10000"  %== R^2 is mult. by 100^2 ==%
set "k=%2"
set "ambient=%3"
rem start draw line-by-line
for /l %%i in (%negR%, 1, %R%) do (
   set /a "x=100*%%i+50"  %== x is mult. by 100 ==%
   set "line="
   for /l %%j in (%twiceNegR%, 1, %twiceR%) do (
      set /a "y=50*%%j+50"  %== y is mult. by 100 ==%
      set /a "pythag = x*x + y*y"
      if !pythag! lss !sqrdR! (
         set /a "vec[0]=x"
         set /a "vec[1]=y"
         set /a "vec[2]=sqrdR-pythag"
         set /a "vec[2]=%sqrt(N):N=!vec[2]!%"  %== sqrt(N) applied ==%
         %normalize% vec  %== normalize macro applied ==%
         %dot% light vec dot_out  %== dot macro applied ==%
         rem since both light and vec are normalized to 100,
         rem then dot_out is scaled up by 100*100 now.
         set /a "dot_out/=100"  %== scale-down to 100*[actual] to prevent overflow before exponentiation ==%
         set "scaleup=1"  %== after exponentiation, b would be scaleup*[actual] ==%
         set "b=1"
         for /l %%? in (1,1,%k%) do set /a "b*=dot_out","scaleup*=100" %== exponentiation ==%
         set /a "b+=ambient*scaleup/10"  %== add ambient/10 to b ==%
         set /a "b/=scaleup/100"  %== scale-down to 100*[actual] ==%
         set /a "intensity=(100-b)*num_shades"
         set /a "intensity/=100"  %== final scale-down ==%
         if !intensity! lss 0 set "intensity=0"
         if !intensity! gtr %num_shades% set "intensity=%num_shades%"
         for %%c in (!intensity!) do set "line=!line!!shades[%%c]!"
      ) else (
         set "line=!line! "
      )
   )
   echo(!line!
)
goto :EOF
