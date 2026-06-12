proc protect _var {
    upvar 1 $_var var
    trace add variable var {write unset} [list protect0 $var]
}
proc protect0 {backup name1 name2 op} {
    upvar 1 $name1 var
    trace remove variable var {write unset} [list protect 0 $backup]
    set var $backup
    trace add variable var {write unset} [list protect0 $backup]
    return -code error "$name1 is protected"
}
proc trying cmd { #-- convenience function for demo
    puts "trying: $cmd"
    if [catch {uplevel 1 $cmd} msg] {puts $msg}
}
