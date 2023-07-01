USING: fry io.encodings.utf8 io.files kernel qw sequences
splitting ;

: global-replace ( files old new -- )
    '[
        [ utf8 file-contents _ _ replace ]
        [ utf8 set-file-contents ] bi
    ] each ;


qw{ a.txt b.txt c.txt }
"Goodbye London!" "Hello New York!" global-replace
