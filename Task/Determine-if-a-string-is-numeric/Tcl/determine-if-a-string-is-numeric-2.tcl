# will output an error message
# and quit
proc fatal {msg} {
    puts stderr "$msg"
    exit 1
}

# a bad string
set x  174gg.4

try {
   set n [expr {double($x)}]
   set n [expr {int($x)}]
   puts $x
   } on error { error options } {
        fatal "$::errorInfo"
   }
