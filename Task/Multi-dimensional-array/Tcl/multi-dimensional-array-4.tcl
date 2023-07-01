% array set x {
    0,0 a
    0,1 b
    1,0 c
    1,1 d
}
% parray x
x(0,0) = a
x(0,1) = b
x(1,0) = c
x(1,1) = d
% puts $x(0,1)
b
% set a 0
1
% set b 1
% puts $x($b,$a)
c
% set $x($b,$a) "not c"
not c
% parray x $b,$a
x(1,0) = not c
