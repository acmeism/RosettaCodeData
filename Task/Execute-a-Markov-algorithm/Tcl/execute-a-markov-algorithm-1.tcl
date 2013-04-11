package require Tcl 8.5
if {$argc < 3} {error "usage: $argv0 ruleFile inputFile outputFile"}
lassign $argv ruleFile inputFile outputFile

# Read the file of rules
set rules {}
set f [open $ruleFile]
foreach line [split [read $f] \n[close $f]] {
    if {[string match "#*" $line] || $line eq ""} continue
    if {[regexp {^(.+)\s+->\s+(\.?)(.*)$} $line -> from final to]} {
	lappend rules $from $to [string compare "." $final] [string length $from]
    } else {
	error "Syntax error: \"$line\""
    }
}

# Apply the rules
set f [open $inputFile]
set out [open $outputFile w]
foreach line [split [read $f] \n[close $f]] {
    set any 1
    while {$any} {
	set any 0
	foreach {from to more fl} $rules {
	    # If we match the 'from' pattern...
	    if {[set idx [string first $from $line]] >= 0} {
		# Change for the 'to' replacement
		set line [string replace $line $idx [expr {$idx+$fl-1}] $to]

		# Stop if we terminate, otherwise note that we've more work to do
        	set any $more
		break;	# Restart search for rules to apply
	    }
	}
        #DEBUG# puts $line
    }

    # Output the processed line
    puts $out $line
}
close $out
