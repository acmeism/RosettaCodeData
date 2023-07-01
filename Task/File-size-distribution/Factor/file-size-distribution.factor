USING: accessors assocs formatting io io.directories.search
io.files.types io.pathnames kernel math math.functions
math.statistics namespaces sequences ;

: classify ( m -- n ) [ 0 ] [ log10 >integer 1 + ] if-zero ;

: file-size-histogram ( path -- assoc )
    recursive-directory-entries
    [ type>> +directory+ = ] reject
    [ size>> classify ] map histogram ;

current-directory get file-size-histogram dup
[ "Count of files < 10^%d bytes: %4d\n" printf ] assoc-each
nl values sum "Total files: %d\n" printf
