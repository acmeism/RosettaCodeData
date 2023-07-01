$! doors.com
$! Excecute by running @doors at prompt.
$ square = 1
$ incr = 3
$ count2 = 0
$ d = 1
$ LOOP2:
$       count2 = count2 + 1
$       IF (d .NE. square)
$               THEN WRITE SYS$OUTPUT "door ''d' is closed"
$       ELSE WRITE SYS$OUTPUT "door ''d' is open"
$               square = incr + square
$               incr = incr + 2
$       ENDIF
$       d = d + 1
$       IF (count2 .LT. 100) THEN GOTO LOOP2
