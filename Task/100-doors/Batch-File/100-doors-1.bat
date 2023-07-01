@echo off
setlocal enableDelayedExpansion
:: 0 = closed
:: 1 = open
:: SET /A treats undefined variable as 0
:: Negation operator ! must be escaped because delayed expansion is enabled
for /l %%p in (1 1 100) do for /l %%d in (%%p %%p 100) do set /a "door%%d=^!door%%d"
for /l %%d in (1 1 100) do if !door%%d!==1 (
  echo door %%d is open
) else echo door %%d is closed
