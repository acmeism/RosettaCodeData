package require Tcl 8.6

proc yahoo! term {
    coroutine yahoo![incr ::yahoo] apply {term {
        yield [info coroutine]
        while 1 {
            set results [YahooSearch $term [incr step]]
            if {[llength $results] == 0} {
                return -code break
            }
            foreach {t c u} $results {
                yield [dict create title $t content $c url $u]
            }
        }
    }} $term
}

# test by getting first fifty titles...
set it [yahoo! "test"]
for {set i 50} {$i>0} {incr i -1} {
    puts [dict get [$it] title]
    after 300  ;# Slow the code down... :-)
}
