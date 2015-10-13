@echo off
EventCreate /t ERROR /id 123 /l SYSTEM /so "A Batch File" /d "This is found in system log." 2>NUL>NUL
EventCreate /t WARNING /id 456 /l APPLICATION /so BlaBla /d "This is found in apps log" 2>NUL>NUL
::That "2>NUL>NUL" trick actually works in any command!
