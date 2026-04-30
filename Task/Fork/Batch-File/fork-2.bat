@echo off
setlocal enableextensions
if defined forked_%~n0 (
  echo I'm the child
  pause
  exit
) else (
  title Parent window
  set forked_%~n0=1
  start "Child window" %~f0
  echo I'm the parent.
  pause
)
