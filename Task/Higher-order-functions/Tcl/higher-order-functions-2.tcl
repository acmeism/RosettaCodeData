# This procedure executes its argument with an extra argument of "2"
proc demoFrag {fragment} {
    {*}$fragment 2
}
# This procedure executes its argument in the context of its caller, which is
# useful for scripts so they get the right variable resolution context
proc demoScript {script} {
    uplevel 1 $script
}

# Examples...
set chan stderr
demoFrag [list puts $chan]
demoFrag {
    apply {x {puts [string repeat ? $x]}}
}
demoScript {
    parray tcl_platform
}
