@echo off
EventCreate /t ERROR /id 123 /l SYSTEM /so "A Batch File" /d "This is found in system log."
EventCreate /t WARNING /id 456 /l APPLICATION /so BlaBla /d "This is found in apps log"
