USING: grouping io.encodings.ascii io.files kernel prettyprint
sequences sets ;

"unixdict.txt" ascii file-lines
[ "abc" within members "abc" = ] filter
5 group simple-table.
