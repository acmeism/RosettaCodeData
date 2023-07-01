USING: csv io.encodings.utf8 kernel math.parser sequences ;
IN: rosetta-code.csv-manipulation

: append-sum ( seq -- seq' )
    dup [ string>number ] map-sum number>string suffix ;

: csv-sums ( seq -- seq' )
    [ 0 = [ "SUM" suffix ] [ append-sum ] if ] map-index ;

"example.csv" utf8 [ file>csv csv-sums ] [ csv>file ] 2bi
