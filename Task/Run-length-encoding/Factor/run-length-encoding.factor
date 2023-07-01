USING: io kernel literals math.parser math.ranges sequences
sequences.extras sequences.repeating splitting.extras
splitting.monotonic strings ;
IN: rosetta-code.run-length-encoding

CONSTANT: alpha $[ CHAR: A CHAR: Z [a,b] >string ]

: encode ( str -- str )
    [ = ] monotonic-split [ [ length number>string ] [ first ]
    bi suffix ] map concat ;

: decode ( str -- str )
    alpha split* [ odd-indices ] [ even-indices
    [ string>number ] map ] bi [ repeat ] 2map concat ;

"WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
"12W1B12W3B24W1B14W"
[ encode ] [ decode ] bi* [ print ] bi@
