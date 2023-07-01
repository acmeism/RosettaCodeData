proc commaQuibble {lst} {
    return \{[join [lreplace $lst end-1 end [join [lrange $lst end-1 end] " and "]] ", "]\}
}

foreach input { {} {"ABC"} {"ABC" "DEF"} {"ABC" "DEF" "G" "H"} } {
    puts [commaQuibble $input]
}
