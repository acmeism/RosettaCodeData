@echo off
setlocal enableDelayedExpansion
set /a square=1, incr=3
for /l %%d in (1 1 100) do (
  if %%d neq !square! (echo door %%d is closed) else (
    echo door %%d is open
    set /a square+=incr, incr+=2
  )
)
