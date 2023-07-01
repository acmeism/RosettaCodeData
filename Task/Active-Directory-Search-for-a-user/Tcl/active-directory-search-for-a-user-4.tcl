foreach pair $result {
    lassign $pair cn attributes
    puts [dict get $attributes distinguishedName]
}
