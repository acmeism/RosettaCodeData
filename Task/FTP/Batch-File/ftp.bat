::Playing with FTP
::Batch File Implementation

@echo off

set site="ftp.hq.nasa.gov"
set user="anonymous"
set pass="ftptest@example.com"
set dir="pub/issoutreach/Living in Space Stories (MP3 Files)"
set download="Gravity in the Brain.mp3"

(
	echo.open %site%
	echo.user %user% %pass%
	echo.dir
	echo.!echo.
	echo.!echo.This is a just a text to seperate two directory listings.
	echo.!echo.
	echo.cd %dir%
	echo.dir
	echo.binary
	echo.get %download%
	echo.disconnect
)|ftp -n
