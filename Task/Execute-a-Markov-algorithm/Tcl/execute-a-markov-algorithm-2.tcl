package require Tcl 8.5
if {$argc < 3} {error "usage: $argv0 ruleFile inputFile outputFile"}
lassign $argv ruleFile inputFile outputFile

# Read the file of rules
set rules {}
set f [open $ruleFile]
foreach line [split [read $f] \n[close $f]] {
    if {[string match "#*" $line] || $line eq ""} continue
    if {[regexp {^(.+)\s+->\s+(.*)$} $line -> from to]} {
        dict set rules $from $to
    } else {
    error "Syntax error: \"$line\""
    }
}

# Apply the rules in a simplistic manner
set in [open $inputFile]
set out [open $outputFile w]
set data [read $in]
close $in
while 1 {
    set newData [string map $rules $data]
    if {$newData eq $data} break
    set data $newData
}
puts $out $data
close $out
