USING: formatting io kernel make regexp sequences sets splitting ;
IN: rosetta-code.mad-libs

: get-mad-lib ( -- str )
    "Enter a mad lib. A blank line signals end of input." print
    [
        [ "> " write flush readln dup , empty? f t ? ] loop
    ] { } make harvest "\n" join ;

: find-replacements ( str -- seq )
    R/ <[\w\s]+>/ all-matching-subseqs members ;

: query ( str -- str )
    rest but-last "Enter a(n) %s: " printf flush readln ;

: replacements ( str seq -- str )
    dup [ query ] map [ replace ] 2each ;

: mad-libs ( -- )
    get-mad-lib dup find-replacements replacements nl print ;

MAIN: mad-libs
