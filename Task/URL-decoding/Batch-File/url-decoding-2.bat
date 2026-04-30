...
certutil -f -decodehex "%hex%" "%hex%" >nul
del "%hex%"
for %%i in (!hexlist!) do (
  set /a dec=0x%%i
  cmd/cexit !dec!
  for %%p in ("%%%%i=!=exitcodeascii!") do set str=!str:%%~p!
)
echo !str!
