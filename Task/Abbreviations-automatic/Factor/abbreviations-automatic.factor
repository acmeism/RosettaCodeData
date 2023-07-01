USING: formatting io io.encodings.utf8 io.files kernel math
sequences sets splitting ;
IN: rosetta-code.abbreviations-automatic

: map-head ( seq n -- seq' ) [ short head ] curry map ;

: unique? ( seq n -- ? ) map-head all-unique? ;

: (abbr-length) ( seq -- n )
    1 [ 2dup unique? ] [ 1 + ] until nip ;

: abbr-length ( str -- n/str )
    [ "" ] [ " " split (abbr-length) ] if-empty ;

: show ( str -- ) dup abbr-length swap " %2u  %s\n" printf ;

: labels ( -- )
    "Min." "abbr" "Days of the week" "%s\n%s%32s\n" printf ;

: line ( n -- ) [ "=" write ] times ;

: header ( -- ) labels 4 line bl 75 line nl ;

: body ( -- ) [ show ] each-line ;

: abbreviations ( -- )
    header "day-names.txt" utf8 [ body ] with-file-reader ;

MAIN: abbreviations
