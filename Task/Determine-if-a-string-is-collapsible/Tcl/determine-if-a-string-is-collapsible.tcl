set test {
    {}
    {"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln }
    {..1111111111111111111111111111111111111111111111111111111111111117777888}
    {I never give 'em hell, I just tell the truth, and they think it's hell. } ;# '
    {                                                    --- Harry S Truman  }
    {The better the 4-wheel drive, the further you'll be from help when ya get stuck!} ;# '
    {headmistressship}
}

foreach {str} $test {
    # Uses regexp lookbehind to detect repeated characters
    set sub [regsub -all {(.)(\1+)} $str {\1}]

    # Output
    puts [format "Original (length %3d): %s" [string length $str] $str]
    puts [format "Subbed   (length %3d): %s" [string length $sub] $sub]
    puts ----------------------
}
