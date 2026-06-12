proc main {args} {
    puts "Directory: [pwd]"
    puts "Program: $::argv0"
    puts "Number of args: [llength $args]"
    foreach arg $args {puts "Arg: $arg"}
}

if {$::argv0 eq [info script]} {
    main {*}$::argv
}
