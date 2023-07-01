% package require Tcl 8.5
8.5.2
% expr inf+1
Inf
% set inf_val [expr {1.0 / 0.0}]
Inf
% set neginf_val [expr {-1.0 / 0.0}]
-Inf
% set negzero_val [expr {1.0 / $neginf_val}]
-0.0
% expr {0.0 / 0.0}
domain error: argument not in valid range
% expr nan
domain error: argument not in valid range
% expr {1/-inf}
-0.0
