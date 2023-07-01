@echo off

(
  echo jsmith:x:1001:1000:Joe Smith,Room 1007,^(234^)555-8917,^(234^)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash
  echo jdoe:x:1002:1000:Jane Doe,Room 1004,^(234^)555-8914,^(234^)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash
) > append.txt

echo Current contents of append.txt:
type append.txt
echo.

echo xyz:x:1003:1000:X Yz,Room 1003,^(234^)555-8913,^(234^)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash >> append.txt

echo New contents of append.txt:
type append.txt
pause>nul
