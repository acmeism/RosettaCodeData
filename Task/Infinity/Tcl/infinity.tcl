package require Tcl 8.5

expr {1.0 / 0}  ;# ==> Inf
expr {-1.0 / 0} ;# ==> -Inf
expr {inf}      ;# ==> Inf
expr {1 / 0}    ;# ==> "divide by zero" error; Inf not part of range of integer division
