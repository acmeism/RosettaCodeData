package require Tcl 8.5
package require Tk 8.5
proc say {text button} {
    grab $button
    $button configure -state disabled -cursor watch
    update
    set starts [$text search -all -regexp -count lengths {\S+} 1.0]
    foreach start $starts length $lengths {
	lappend strings [$text get $start "$start + $length char"]
	lappend ends [$text index "$start + $length char"]
    }
    $text tag remove sel 1.0 end
    foreach from $starts str $strings to $ends {
	$text tag add sel $from $to
	update idletasks
	exec /usr/bin/say << $str
	$text tag remove sel 1.0 end
    }
    grab release $button
    $button configure -state normal -cursor {}
}

pack [text .t]
pack [button .b -text "Speak, computer!" -command {say .t .b}] -fill x
.t insert 1.0 "This is an example of speech synthesis with Tcl/Tk."
