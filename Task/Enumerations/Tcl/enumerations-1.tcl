proc enumerate {name values} {
    interp alias {} $name: {} lsearch $values
    interp alias {} $name@ {} lindex $values
}
