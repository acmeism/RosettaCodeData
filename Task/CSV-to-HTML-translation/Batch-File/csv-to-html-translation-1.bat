::Batch Files are terrifying when it comes to string processing.
::But well, a decent implementation!
@echo off

REM Below is the CSV data to be converted.
REM Exactly three colons must be put before the actual line.

:::Character,Speech
:::The multitude,The messiah! Show us the messiah!
:::Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
:::The multitude,Who are you?
:::Brians mother,I'm his mother; that's who!
:::The multitude,Behold his mother! Behold his mother!

setlocal disabledelayedexpansion
echo ^<table^>
for /f "delims=" %%A in ('findstr "^:::" "%~f0"') do (
   set "var=%%A"
   setlocal enabledelayedexpansion
      REM The next command removes the three colons...
      set "var=!var:~3!"

      REM The following commands to the substitions per line...
      set "var=!var:&=&amp;!"
      set "var=!var:<=&lt;!"
      set "var=!var:>=&gt;!"
      set "var=!var:,=</td><td>!"

      echo ^<tr^>^<td^>!var!^</td^>^</tr^>
   endlocal
)
echo ^</table^>
