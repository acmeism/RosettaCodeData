@echo off

::set "var" as a blank string.
set var=

::check if "var" is a blank string.
if not defined var echo Var is a blank string.
::Alternatively,
if %var%@ equ @ echo Var is a blank string.

::check if "var" is not a blank string.
if defined var echo Var is defined.
::Alternatively,
if %var%@ neq @ echo Var is not a blank string.
