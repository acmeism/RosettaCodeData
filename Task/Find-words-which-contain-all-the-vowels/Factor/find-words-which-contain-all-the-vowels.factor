USING: grouping io.encodings.ascii io.files math prettyprint
sequences sets.extras ;

"unixdict.txt" ascii file-lines
[ length 10 > ] filter
[ non-repeating "aeiou" superset? ] filter
5 group simple-table.
