@echo off
setlocal enabledelayedexpansion
(set lf=^

)
(set stack=
set stack.push=set "stack=#^!lf^!^!stack^!"
set stack.pop=for %%l in ("^!lf^!"^) do set "stack=^!stack:*%%~l=^!"
set stack.empty=(call;^&if defined stack call^)
set stack.top=echo:^^!stack^^! ^| (set /p _=^& call echo:%%_%%^))
:: ^ stack.top : https://stackoverflow.com/a/14965458
%stack.push:#=1%
%stack.push:#=2%
%stack.top%
for %%l in ("!lf!") do echo:"!stack:%%~l= !"
%stack.pop%
for %%l in ("!lf!") do echo:"!stack:%%~l= !"
%stack.empty% && echo empty: true || echo empty: false
%stack.pop%
for %%l in ("!lf!") do echo:"!stack:%%~l= !"
%stack.empty% && echo empty: true || echo empty: false
goto:eof
