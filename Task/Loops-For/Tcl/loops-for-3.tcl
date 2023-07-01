set line ""
for { set io [open test.txt r] } { ![eof $io] } { gets $io line } {
    if { $line != "" } { ...do something here... }
}
