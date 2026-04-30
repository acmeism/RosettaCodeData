for /F %%a in ('prompt $E ^& for %%a in ^(1^) do rem') do set "\e=%%a"
<nul set/p=%\e%[?25l
