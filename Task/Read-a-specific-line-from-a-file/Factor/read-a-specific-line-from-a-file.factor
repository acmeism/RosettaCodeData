USING: continuations fry io io.encodings.utf8 io.files kernel
math ;
IN: rosetta-code.nth-line

: nth-line ( path encoding n -- str/f )
    [ f ] 3dip '[
        [ _ [ drop readln [ return ] unless* ] times ]
        with-return
    ] with-file-reader ;

: nth-line-demo ( -- )
    "input.txt" utf8 7 nth-line [ "line not found" ] unless*
    print ;

MAIN: nth-line-demo
