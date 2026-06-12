#!/usr/bin/env tclsh

# State class implementation
proc State {label} {
    return [dict create label $label edge1 {} edge2 {}]
}

# NFA class implementation
proc NFA {initial accept} {
    return [dict create initial $initial accept $accept]
}

# Helper function to check if a state list contains a specific state
proc contains_state {states target} {
    foreach state $states {
        if {$state eq $target} {
            return 1
        }
    }
    return 0
}

# Compute the epsilon closure of the given state
proc followes {state} {
    set states {}
    set stack [list $state]

    while {[llength $stack] > 0} {
        set current [lindex $stack end]
        set stack [lrange $stack 0 end-1]

        if {![contains_state $states $current]} {
            lappend states $current
            set label [dict get $current label]
            if {$label eq "\0"} {
                set edge1 [dict get $current edge1]
                set edge2 [dict get $current edge2]
                if {$edge1 ne {}} {
                    lappend stack $edge1
                }
                if {$edge2 ne {}} {
                    lappend stack $edge2
                }
            }
        }
    }

    return $states
}

# Convert the given infix regex to postfix regex using the Shunting Yard algorithm
proc shunt {infix} {
    array set specials {
        "*" 60
        "+" 55
        "?" 50
        "." 40
        "|" 20
    }

    set stack {}
    set postfix ""

    for {set i 0} {$i < [string length $infix]} {incr i} {
        set ch [string index $infix $i]

        if {$ch eq "("} {
            lappend stack $ch
        } elseif {$ch eq ")"} {
            while {[llength $stack] > 0 && [lindex $stack end] ne "("} {
                append postfix [lindex $stack end]
                set stack [lrange $stack 0 end-1]
            }
            if {[llength $stack] > 0} {
                set stack [lrange $stack 0 end-1]
            }
        } elseif {[info exists specials($ch)]} {
            while {[llength $stack] > 0 &&
                   [info exists specials([lindex $stack end])] &&
                   $specials($ch) <= $specials([lindex $stack end])} {
                append postfix [lindex $stack end]
                set stack [lrange $stack 0 end-1]
            }
            lappend stack $ch
        } else {
            append postfix $ch
        }
    }

    while {[llength $stack] > 0} {
        append postfix [lindex $stack end]
        set stack [lrange $stack 0 end-1]
    }

    return $postfix
}

# Compile the given postfix regex into an NFA
proc compile_regex {postfix} {
    set nfa_stack {}

    for {set i 0} {$i < [string length $postfix]} {incr i} {
        set ch [string index $postfix $i]

        if {$ch eq "*"} {
            set nfa1 [lindex $nfa_stack end]
            set nfa_stack [lrange $nfa_stack 0 end-1]

            set initial [State "\0"]
            set accept [State "\0"]
            dict set initial edge1 [dict get $nfa1 initial]
            dict set initial edge2 $accept

            set nfa1_accept [dict get $nfa1 accept]
            dict set nfa1_accept edge1 [dict get $nfa1 initial]
            dict set nfa1_accept edge2 $accept

            lappend nfa_stack [NFA $initial $accept]
        } elseif {$ch eq "."} {
            set nfa2 [lindex $nfa_stack end]
            set nfa_stack [lrange $nfa_stack 0 end-1]
            set nfa1 [lindex $nfa_stack end]
            set nfa_stack [lrange $nfa_stack 0 end-1]

            set nfa1_accept [dict get $nfa1 accept]
            dict set nfa1_accept edge1 [dict get $nfa2 initial]

            lappend nfa_stack [NFA [dict get $nfa1 initial] [dict get $nfa2 accept]]
        } elseif {$ch eq "|"} {
            set nfa2 [lindex $nfa_stack end]
            set nfa_stack [lrange $nfa_stack 0 end-1]
            set nfa1 [lindex $nfa_stack end]
            set nfa_stack [lrange $nfa_stack 0 end-1]

            set initial [State "\0"]
            set accept [State "\0"]
            dict set initial edge1 [dict get $nfa1 initial]
            dict set initial edge2 [dict get $nfa2 initial]

            set nfa1_accept [dict get $nfa1 accept]
            set nfa2_accept [dict get $nfa2 accept]
            dict set nfa1_accept edge1 $accept
            dict set nfa2_accept edge1 $accept

            lappend nfa_stack [NFA $initial $accept]
        } elseif {$ch eq "+"} {
            set nfa1 [lindex $nfa_stack end]
            set nfa_stack [lrange $nfa_stack 0 end-1]

            set initial [State "\0"]
            set accept [State "\0"]
            dict set initial edge1 [dict get $nfa1 initial]

            set nfa1_accept [dict get $nfa1 accept]
            dict set nfa1_accept edge1 [dict get $nfa1 initial]
            dict set nfa1_accept edge2 $accept

            lappend nfa_stack [NFA $initial $accept]
        } elseif {$ch eq "?"} {
            set nfa1 [lindex $nfa_stack end]
            set nfa_stack [lrange $nfa_stack 0 end-1]

            set initial [State "\0"]
            set accept [State "\0"]
            dict set initial edge1 [dict get $nfa1 initial]
            dict set initial edge2 $accept

            set nfa1_accept [dict get $nfa1 accept]
            dict set nfa1_accept edge1 $accept

            lappend nfa_stack [NFA $initial $accept]
        } else {
            # Literal character
            set initial [State $ch]
            set accept [State "\0"]
            dict set initial edge1 $accept

            lappend nfa_stack [NFA $initial $accept]
        }
    }

    return [lindex $nfa_stack end]
}

# Match the given string against the given infix regex
proc match_regex {text infix} {
    set postfix [shunt $infix]
    # Uncomment the next line to see the postfix expression
    # puts "Postfix: $postfix"

    set nfa [compile_regex $postfix]

    set current [followes [dict get $nfa initial]]
    set next_states {}

    for {set i 0} {$i < [string length $text]} {incr i} {
        set ch [string index $text $i]
        foreach state $current {
            set label [dict get $state label]
            if {$label eq $ch} {
                set edge1 [dict get $state edge1]
                set follow [followes $edge1]
                foreach s $follow {
                    lappend next_states $s
                }
            }
        }
        set current $next_states
        set next_states {}
    }

    return [contains_state $current [dict get $nfa accept]]
}

# Main function
proc main {} {
    set infixes {"a.b.c*" "a.(b|d).c*" "(a.(b|d))*" "a.(b.b)*.c"}
    set strings {"" "abc" "abbc" "abcc" "abad" "abbbc"}

    foreach infix $infixes {
        foreach string $strings {
            set result [match_regex $string $infix]
            if {$result} {
                puts "True  $infix $string"
            } else {
                puts "False $infix $string"
            }
        }
        puts ""
    }
}

# Run the main function
main
