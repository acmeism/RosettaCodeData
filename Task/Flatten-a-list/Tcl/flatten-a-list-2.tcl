proc flatten {data} {
    while { $data != [set data [join $data]] } { }
    return $data
}
puts [flatten {{1} 2 {{3 4} 5} {{{}}} {{{6}}} 7 8 {}}]
# ===> 1 2 3 4 5 6 7 8
