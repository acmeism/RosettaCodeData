catch {console show}          ;## show console when running from tclwish
catch {wm withdraw .}

set filename "data.txt"
set fh [open $filename]
set NR 0                ;# number-of-record, means linenumber

while {[gets $fh line]>=0} {        ;# gets returns length of line, -1 means eof
    incr NR
    set  line2 [regexp -all -inline {\S+} $line]  ;# reduce multiple whitespace
    set  fld   [split $line2]   ;# split line into fields, at whitespace
    set  f3    [lindex $fld 2]  ;# zero-based
   #set  NF    [llength $fld]       ;# number-of-fields

    if {$f3 > 6} { puts "$line" }
}
close $fh
