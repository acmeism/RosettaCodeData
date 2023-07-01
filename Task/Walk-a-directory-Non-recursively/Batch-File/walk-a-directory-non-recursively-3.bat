for /F "tokens=*" %F in ('dir /b "%windir%\system32\*.exe"') do echo %F
