; Capture output to string variable:

x: ""  call/output "dir" x
print x

; The 'console' refinement displays the command output on the REBOL command line.

call/console "dir *.r"
call/console "ls *.r"

call/console "pause"

; The 'shell' refinement may be necessary to launch some programs.

call/shell "notepad.exe"
