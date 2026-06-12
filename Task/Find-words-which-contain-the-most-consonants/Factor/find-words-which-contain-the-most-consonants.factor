USING: assocs formatting io.encodings.ascii io.files kernel math
prettyprint prettyprint.config sequences sets sets.extras ;
FROM: namespaces => set ;

"unixdict.txt" ascii file-lines
[ length 10 > ] filter
[ "aeiou" without all-unique? ] filter dup length
"Found %d words with unique consonants (length > 10).\n" printf
[ [ "aeiou" member? not ] count ] collect-by >alist reverse

6 length-limit set 100 margin set .
