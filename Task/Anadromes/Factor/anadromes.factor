USING: assocs grouping hash-sets io.encodings.ascii io.files
kernel math prettyprint sequences sets sets.extras ;

"words.txt" ascii file-lines [ length 6 > ] filter dup >hash-set '[ reverse _ in? ] filter
[ reverse ] zip-with [ all-equal? ] reject [ fast-set ] unique-by .
