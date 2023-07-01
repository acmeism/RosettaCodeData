if {[llength $result] == 1} {
    puts [dict get [lindex $result 0 1] distinguishedName]
}
