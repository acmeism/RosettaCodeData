USING: io io.encodings.ascii io.files kernel math sequences ;

"unixdict.txt" ascii file-lines
[ length 11 > ] filter
[ "the" swap subseq? ] filter
[ print ] each
