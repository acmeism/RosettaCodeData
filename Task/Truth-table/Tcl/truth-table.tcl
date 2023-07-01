package require Tcl 8.5

puts -nonewline "Enter a boolean expression: "
flush stdout
set exp [gets stdin]

# Generate the nested loops as the body of a lambda term.
set vars [lsort -unique [regexp -inline -all {\$\w+} $exp]]
set cmd [list format [string repeat "%s\t" [llength $vars]]%s]
append cmd " {*}\[[list subst $vars]\] \[[list expr $exp]\]"
set cmd "puts \[$cmd\]"
foreach v [lreverse $vars] {
    set cmd [list foreach [string range $v 1 end] {0 1} $cmd]
}

puts [join $vars \t]\tResult
apply [list {} $cmd]
