set input 0
while {$input != 75000} {
    puts -nonewline "enter the number '75000': "
    flush stdout
    set input [gets stdin]
}
