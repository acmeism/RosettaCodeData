USING: grouping kernel math.text.utils present prettyprint
sequences ;

1000 <iota>
[ [ 1 digit-groups sum present ] [ present ] bi subseq? ] filter
8 group simple-table.
