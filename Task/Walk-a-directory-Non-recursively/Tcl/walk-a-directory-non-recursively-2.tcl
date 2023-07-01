set dir /foo/bar
foreach filename [glob -directory $dir *.txt] {
    puts $filename
    ### Or, if you only want the local filename part...
    # puts [file tail $filename]
}
