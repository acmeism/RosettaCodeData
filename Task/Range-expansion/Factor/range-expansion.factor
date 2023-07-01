USING: kernel math.parser math.ranges prettyprint regexp
sequences sequences.extras splitting ;

: expand ( str -- seq )
    "," split [
        R/ (?<=\d)-/ re-split [ string>number ] map
        dup length 2 = [ first2 [a,b] ] when
    ] map-concat ;

"-6,-3--1,3-5,7-11,14,15,17-20" expand .
