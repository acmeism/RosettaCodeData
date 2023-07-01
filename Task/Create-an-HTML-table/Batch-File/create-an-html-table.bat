@echo off
setlocal enabledelayedexpansion

:: It's easier and neater to create the variables holding the random 4 digit numbers ahead of time
for /l %%i in (1,1,12) do set /a rand%%i=!random! %% 9999

:: The command output of everything within the brackets is sent to the file "table.html", overwriting anything already in there
(
  echo ^<html^>^<head^>^</head^>^<body^>
  echo ^<table border=1 cellpadding=10 cellspacing=0^>
  echo ^<tr^>^<th^>^</th^>
  echo ^<th^>X^</th^>
  echo ^<th^>Y^</th^>
  echo ^<th^>Z^</th^>
  echo ^</tr^>
  echo ^<tr^>^<th^>1^</th^>
  echo ^<td align="right"^>%rand1%^</td^>
  echo ^<td align="right"^>%rand2%^</td^>
  echo ^<td align="right"^>%rand3%^</td^>
  echo ^</tr^>
  echo ^<tr^>^<th^>2^</th^>
  echo ^<td align="right"^>%rand4%^</td^>
  echo ^<td align="right"^>%rand5%^</td^>
  echo ^<td align="right"^>%rand6%^</td^>
  echo ^</tr^>
  echo ^<tr^>^<th^>3^</th^>
  echo ^<td align="right"^>%rand7%^</td^>
  echo ^<td align="right"^>%rand8%^</td^>
  echo ^<td align="right"^>%rand9%^</td^>
  echo ^</tr^>
  echo ^<tr^>^<th^>4^</th^>
  echo ^<td align="right"^>%rand10%^</td^>
  echo ^<td align="right"^>%rand11%^</td^>
  echo ^<td align="right"^>%rand12%^</td^>
  echo ^</tr^>
  echo ^</table^>
  echo ^</body^>^</html^>
) > table.html
start table.html
