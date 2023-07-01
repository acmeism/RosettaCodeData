chan configure stdin  -translation binary
chan configure stdout -translation binary

set lines [regexp -inline -all {.{80}} [read stdin]]
puts -nonewline [join [lmap line $lines {string reverse $line}] ""]

# More "traditional" way

# while {[set line [read stdin 80]] ne ""} {
# 	puts -nonewline [string reverse $line]
# }
