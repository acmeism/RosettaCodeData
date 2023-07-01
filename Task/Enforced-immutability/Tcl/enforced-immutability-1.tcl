proc constant {varName {value ""}} {
    upvar 1 $varName var
    # Allow application of immutability to an existing variable, e.g., a procedure argument
    if {[llength [info frame 0]] == 2} {set value $var} else {set var $value}
    trace add variable var write [list apply {{val v1 v2 op} {
        upvar 1 $v1 var
        set var $val; # Restore to what it should be
        return -code error "immutable"
    }} $value]
}
