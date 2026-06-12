@echo off
setlocal enableextensions
set tempfile="%temp%\hexdump.tmp"
certutil -encodehex -f %1 %tempfile%>nul || (
  1>&2 echo File not found: %1
  goto :eof
)
type %tempfile%
del %tempfile%
