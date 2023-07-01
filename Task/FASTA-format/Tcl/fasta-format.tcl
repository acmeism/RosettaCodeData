proc fastaReader {filename} {
    set f [open $filename]
    set sep ""
    while {[gets $f line] >= 0} {
	if {[string match >* $line]} {
	    puts -nonewline "$sep[string range $line 1 end]: "
	    set sep "\n"
	} else {
	    puts -nonewline $line
	}
    }
    puts ""
    close $f
}

fastaReader ./rosettacode.fas
