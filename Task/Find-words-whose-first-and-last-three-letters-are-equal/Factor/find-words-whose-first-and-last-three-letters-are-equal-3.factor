USING: io io.encodings.ascii io.files kernel lists lists.lazy
math sequences ;

"unixdict.txt" ascii <file-reader> llines
[ length 5 > ] lfilter
[ [ 3 head-slice ] [ 3 tail-slice* ] bi = ] lfilter
[ print ] leach
