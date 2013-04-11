% set a [example new]
::oo::Obj20
% set b [example new]  ;# note how this returns the same object name
::oo::Obj20
% expr {$a == $b}
1
% $a counter
1
% $b counter
2
% $a counter
3
% $b counter
4
