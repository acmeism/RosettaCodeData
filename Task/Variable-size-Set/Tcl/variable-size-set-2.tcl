% proc range_trace {n _var el op} {upvar 1 $_var v; set v [string range $v 0 [incr n -1]]}

% trace var baz w {range_trace 2}
% set baz Frankfurt
Fr
