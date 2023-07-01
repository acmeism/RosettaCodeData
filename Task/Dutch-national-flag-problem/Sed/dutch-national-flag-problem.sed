:la
s/\(WW*\)\([RB].*\)/\2\1/
t la
:lb
s/\(BB*\)\([RW].*\)/\2\1/
t lb
/^RR*WW*BB*$/!d
