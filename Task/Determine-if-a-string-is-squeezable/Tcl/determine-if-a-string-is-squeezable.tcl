# Set test data as a list pairing even and odd values
# as test string and squeeze character(s) respectively.
set test {
    {} {" "}
    {"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln } {"-"}
    {..1111111111111111111111111111111111111111111111111111111111111117777888} {"7"}
    {I never give 'em hell, I just tell the truth, and they think it's hell. } {"."} ;# '
    {                                                    --- Harry S Truman  } {" " "-" "r"}
    {The better the 4-wheel drive, the further you'll be from help when ya get stuck!} {"e"} ;# '
    {headmistressship} {"s"}
}

foreach {str chrs} $test {
    foreach c $chrs {
        # Escape non-word replacement characters (such as .)
        set c [regsub -all {\W} $c {\\&}]

        # Uses regexp lookbehind to detect repeated characters
        set re [subst -noback {($c)(\1+)}] ;# build expression
        set sub [regsub -all $re $str {\1}]

        # Output
        puts [format "Original (length %3d): %s" [string length $str] $str]
        puts [format "Subbed   (length %3d): %s" [string length $sub] $sub]
        puts ----------------------
    }
}
