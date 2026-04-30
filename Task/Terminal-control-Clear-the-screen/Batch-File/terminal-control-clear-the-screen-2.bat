for /F %%a in ('prompt $E ^& for %%a in ^(1^) do rem') do set "\e=%%a"
echo %\e%[2J
