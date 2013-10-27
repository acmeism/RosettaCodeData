signal on error
signal on failure
signal on halt
signal on lostdigits
signal on notready
signal on novalue
signal on syntax

signal off error
signal off failure
signal off halt
signal off lostdigits
signal off notready
signal off novalue
signal off syntax
...
signal on novalue
...
x=oopsay+1
...
novalue: say
say '*** error! ***'
say
say 'undefined REXX variable' condition("D")
say
say 'in line' sigl
say
say 'REXX source statement is:'
say sourceline(sigl)
say
exit 13
...
