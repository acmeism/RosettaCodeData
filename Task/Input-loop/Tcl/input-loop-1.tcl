set fh [open $filename]
while {[gets $fh line] != -1} {
    # process $line
}
close $fh
