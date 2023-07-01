set fh [open $filename]
set data [read $fh]
close $fh
foreach line [split $data \n] {
    # process line
}
