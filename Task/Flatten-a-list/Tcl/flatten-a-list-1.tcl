proc flatten list {
    for {set old {}} {$old ne $list} {} {
        set old $list
        set list [join $list]
    }
    return $list
}

puts [flatten {{1} 2 {{3 4} 5} {{{}}} {{{6}}} 7 8 {}}]
# ===> 1 2 3 4 5 6 7 8
