proc initThieleTest {} {
    for {set i 0} {$i < 32} {incr i} {
	lappend trigTable(x)   [set x [expr {0.05 * $i}]]
	lappend trigTable(sin) [expr {sin($x)}]
	lappend trigTable(cos) [expr {cos($x)}]
	lappend trigTable(tan) [expr {tan($x)}]
    }

    thiele invSin : $trigTable(sin) -> $trigTable(x)
    thiele invCos : $trigTable(cos) -> $trigTable(x)
    thiele invTan : $trigTable(tan) -> $trigTable(x)
}
initThieleTest
puts "pi estimate using sin interpolation: [expr {6 * [invSin 0.5]}]"
puts "pi estimate using cos interpolation: [expr {3 * [invCos 0.5]}]"
puts "pi estimate using tan interpolation: [expr {4 * [invTan 1.0]}]"
