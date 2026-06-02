# calls cmd with args
# retpeatedly in scope above
proc trampoline {cmd args} {

    # thunk is  {cmd {arg1 arg2 arg3 ...} }
    set result [uplevel 1 [concat $cmd $args]]

    # split into vars
    lassign $result type thunk

    # loop
    while {$type eq "next"} {	
        set result [uplevel 1 $thunk]
	    lassign $result type thunk
    }

    set final_value  $thunk

    return $final_value
}

# return  { value final_value    }
#     or  { next {cmd arg1 arg2} }
proc factorial_step {n result} {

    if {$n <= 1} {
	    set ret_value [list "value" $result]
    } else {

	    # n-1
	    set next_n [expr {$n-1}]

	    # (n-1) * fact(n)
	    set next_result [expr {$n * $result}]
	
	    #  {func arg1 arg2}
	    set next_thunk [list factorial_step $next_n $next_result]

	    # Return the next step as a list
	    set ret_value [list "next" $next_thunk]
     }

    return $ret_value
}


# The execution is wrapped by the trampoline
proc factorial {n} {
    return [trampoline factorial_step $n 1]
}

set f [factorial 100]

