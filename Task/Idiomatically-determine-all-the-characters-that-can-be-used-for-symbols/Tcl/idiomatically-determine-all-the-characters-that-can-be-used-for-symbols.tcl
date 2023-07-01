for {set c 0;set printed 0;set special {}} {$c <= 0xffff} {incr c} {
    set ch [format "%c" $c]
    set v "_${ch}_"
    #puts "testing variable named $v"
    if {[catch {set $v $c; set $v} msg] || $msg ne $c} {
	puts [format "\\u%04x illegal in names" $c]
	incr printed
    } elseif {[catch {subst $$v} msg] == 0 && $msg eq $c} {
	lappend special $ch
    }
}
if {$printed == 0} {
    puts "All Unicode characters legal in names"
}
puts "Characters legal after \$: $special"
