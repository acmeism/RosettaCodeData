USING: combinators.short-circuit io.backend io.files
io.pathnames kernel sequences ;
IN: io.directories
: make-directories ( path -- )
    normalize-path trim-tail-separators dup
    { [ "." = ] [ root-directory? ] [ empty? ] [ exists? ] } 1||
    [ make-parent-directories dup make-directory ] unless drop ;
