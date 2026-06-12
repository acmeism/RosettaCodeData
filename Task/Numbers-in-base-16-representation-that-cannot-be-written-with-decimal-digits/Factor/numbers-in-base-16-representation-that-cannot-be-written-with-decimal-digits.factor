USING: kernel math.combinatorics math.parser prettyprint
sequences.extras ;

"ABCDEF" { 1 2 } [ [ hex> ] map-selections ] with map-concat .
