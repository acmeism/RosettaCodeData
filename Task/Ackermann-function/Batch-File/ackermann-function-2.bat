::Ack.cmd
@echo off
cmd/c ackermann.cmd %1 %2
echo Ackermann(%1, %2)=%errorlevel%
