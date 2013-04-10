package require Tcl 8.5
package require Tk

array set door_status {}

# create the gui
set doors [list x]
for {set i 0} {$i < 10} {incr i} {
    for {set j 0} {$j < 10} {incr j} {
        set k [expr {1 + $j + 10*$i}]
        lappend doors [radiobutton .d_$k -text $k -variable door_status($k) \
                         -indicatoron no -offrelief flat -width 3 -value open]
        grid [lindex $doors $k] -column $j -row $i
    }
}

# create the controls
button .start -command go -text Start
label .i_label -text " door:"
entry .i -textvariable i -width 4
label .step_label -text " step:"
entry .step -textvariable step -width 4
grid .start - .i_label - .i - .step_label - .step - -row $i
grid configure .start -sticky ew
grid configure .i_label .step_label -sticky e
grid configure .i .step -sticky w

proc go {} {
    global doors door_status i step

    # initialize the door_status (all closed)
    for {set d 1} {$d <= 100} {incr d} {
        set door_status($d) closed
    }

    # now, begin opening and closing
    for {set step 1} {$step <= 100} {incr step} {
        for {set i 1} {$i <= 100} {incr i} {
            if {$i % $step == 0} {
                [lindex $doors $i] [expr {$door_status($i) eq "open" ? "deselect" : "select"}]
                update
                after 50
            }
        }
    }
}
