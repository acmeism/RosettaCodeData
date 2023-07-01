% format %lx -1      ;# all bits set
ffffffffffffffff

% regsub f 0x[format %lx -1] 7 ;# unset the sign bit for positive
0x7fffffffffffffff

% set ii [expr [regsub f 0x[format %lx -1] 7]] ;# show as decimal
9223372036854775807

% incr ii
9223372036854775808 ;# silently upgrade to unbounded integer, still positive
