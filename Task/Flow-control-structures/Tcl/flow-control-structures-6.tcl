proc forfilelines {linevar filename code} {
    upvar $linevar line ; # connect local variable line to caller's variable
    set filechan [open $filename]
    while {[gets $filechan line] != -1} {
      uplevel 1 $code   ; # Run supplied code in caller's scope
    }
    close $filechan
}
