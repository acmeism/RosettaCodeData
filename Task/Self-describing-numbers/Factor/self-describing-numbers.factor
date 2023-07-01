USING: kernel math.parser prettyprint sequences ;
IN: rosetta-code.self-describing-numbers

: digits ( n -- seq ) number>string string>digits ;

: digit-count ( seq n -- m ) [ = ] curry count ;

: self-describing-number? ( n -- ? )
    digits dup [ digit-count = ] with map-index [ t = ] all? ;

100,000,000 <iota> [ self-describing-number? ] filter .
