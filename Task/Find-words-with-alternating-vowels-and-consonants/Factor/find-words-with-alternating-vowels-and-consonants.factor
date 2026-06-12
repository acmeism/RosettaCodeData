USING: grouping.extras io.encodings.ascii io.files kernel math
prettyprint sequences ;

"unixdict.txt" ascii file-lines
[ length 9 > ] filter
[ dup [ "aeiou" member? ] group-by [ length ] same? ] filter .
