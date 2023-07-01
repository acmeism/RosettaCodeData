@echo off
EventCreate /t ERROR /id 123 /l SYSTEM /so "A Batch File" /d "This is found in system log." >NUL 2>&1
EventCreate /t WARNING /id 456 /l APPLICATION /so BlaBla /d "This is found in apps log" >NUL 2>&1
::That ">NUL 2>&1" trick actually works in any command!
