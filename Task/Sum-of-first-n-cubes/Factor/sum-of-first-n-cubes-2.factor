USING: grouping kernel math prettyprint sequences ;

: triangular ( n -- m ) dup 1 + * 2/ ;

50 <iota> [ triangular sq ] map 10 group simple-table.
