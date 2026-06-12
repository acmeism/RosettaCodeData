package require Tcl 8.5

proc between {str start end} {
    set f [string first $start $str ]
    if {$f < 0} { return "" }
    incr f [string length $start]
    set e [string first $end   $str $f]
    return [string range $str $f [expr {($e < 0) ? "end" : $e-1}]]
}

## data is taken from "Factor"
set L {
        { "Hello Rosetta Code world" "Hello " " world" }
        { "Hello Rosetta Code world" "start" " world" }
        { "Hello Rosetta Code world" "Hello " "end" }
        { "</div><div style=\"chinese\">你好嗎</div>" "<div style=\"chinese\">" "</div>" }
        { "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">" "<text>" "<table>" }
        { "<table style=\"myTable\"><tr><td>hello world</td></tr></table>" "<table>" "</table>" }
        { "The quick brown fox jumps over the lazy other fox" "quick " " fox" }
        { "One fish two fish red fish blue fish" "fish " " red" }
        { "FooBarBazFooBuxQuux" "Foo" "Foo" }
    }

foreach x $L {
    puts " "
    lappend x [between {*}$x]
    foreach v $x t { "Text" "Start delimiter" "End delimiter" "Output" } {
        puts " [format %15s $t]: $v"
    }
}
