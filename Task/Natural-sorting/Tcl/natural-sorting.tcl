package require Tcl 8.5

proc sortWithCollationKey {keyBuilder list} {
    if {![llength $list]} return
    foreach value $list {
	lappend toSort [{*}$keyBuilder $value]
    }
    foreach idx [lsort -indices $toSort] {
	lappend result [lindex $list $idx]
    }
    return $result
}
proc normalizeSpaces {str} {
    regsub -all {[ ]+} [string trim $str " "] " "
}
proc equivalentWhitespace {str} {
    regsub -all {\s} $str " "
}

proc show {description sorter strings} {
    puts "Input:\n\t[join $strings \n\t]"
    set sorted [lsort $strings]
    puts "Normally sorted:\n\t[join $sorted \n\t]"
    set sorted [{*}$sorter $strings]
    puts "Naturally sorted with ${description}:\n\t[join $sorted \n\t]"
}

# Two demonstrations of the space normalizer
show "normalized spaces" {sortWithCollationKey normalizeSpaces} {
    {ignore leading spaces: 2-2}
    { ignore leading spaces: 2-1}
    {  ignore leading spaces: 2+0}
    {   ignore leading spaces: 2+1}}
show "normalized spaces" {sortWithCollationKey normalizeSpaces} {
    {ignore m.a.s spaces: 2-2}
    {ignore m.a.s  spaces: 2-1}
    {ignore m.a.s   spaces: 2+0}
    {ignore m.a.s    spaces: 2+1}}

# Use a collation key that maps all whitespace to spaces
show "all whitespace equivalent" {sortWithCollationKey equivalentWhitespace} {
    "Equiv. spaces: 3-3"
    "Equiv.\rspaces: 3-2"
    "Equiv.\u000cspaces: 3-1"
    "Equiv.\u000bspaces: 3+0"
    "Equiv.\nspaces: 3+1"
    "Equiv.\tspaces: 3+2"}

# These are built-in modes
show "(built-in) case insensitivity" {lsort -nocase} {
    {cASE INDEPENENT: 3-2}
    {caSE INDEPENENT: 3-1}
    {casE INDEPENENT: 3+0}
    {case INDEPENENT: 3+1}}
show "digit sequences as numbers" {lsort -dictionary} {
    foo100bar99baz0.txt
    foo100bar10baz0.txt
    foo1000bar99baz10.txt
    foo1000bar99baz9.txt}
