proc do_stuff {line} {
    puts $line
}

foreach - [lrepeat [gets stdin] dummy] {
    do_stuff [gets stdin]
}
