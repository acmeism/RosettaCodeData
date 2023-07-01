package require Tcl 8.5

lassign $argv bpm bpb
if {$argc < 2} {set bpb 4}
if {$argc < 1} {set bpm 60}

fconfigure stdout -buffering none
set intervalMS [expr {round(60000.0 / $bpm)}]
set ctr 0

proc beat {} {
    global intervalMS ctr bpb
    after $intervalMS beat      ;# Reschedule first, to encourage minimal drift
    if {[incr ctr] == 1} {
	puts -nonewline "\r\a[string repeat { } [expr {$bpb+4}]]\rTICK"
    } else {
	puts -nonewline "\rtick[string repeat . [expr {$ctr-1}]]"
    }
    if {$ctr >= $bpb} {
	set ctr 0
    }
}

# Run the metronome until the user uses Ctrl+C...
beat
vwait forever
