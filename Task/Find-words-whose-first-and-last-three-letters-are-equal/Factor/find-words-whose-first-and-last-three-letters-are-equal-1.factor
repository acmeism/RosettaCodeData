USING: io io.encodings.ascii io.files kernel math sequences ;

"unixdict.txt" ascii file-lines
[ length 5 > ] filter
[ [ 3 head-slice ] [ 3 tail-slice* ] bi = ] filter
[ print ] each
