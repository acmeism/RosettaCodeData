# process the value as if it's a string
proc int2bits {i} {
    string map {0 000 1 001 2 010 3 011 4 100 5 101 6 110 7 111} [format %o $i]
}

# format the number string as an integer, then scan into a binary string
proc int2bits {i} {
    binary scan [binary format I1 $i] B* x
    return $x
}
