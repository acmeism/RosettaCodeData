USING: interpolate io kernel math.parser sequences ;

: bin>dec ( x -- y )
    number>string "0b${}p0" interpolate>string string>number ;

23.34375 dup >bin
1011.11101 dup bin>dec [ [I ${} => ${}I] nl ] 2bi@
