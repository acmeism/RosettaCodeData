: showbytes ( c-addr u -- )
    over + swap ?do
	i c@ 3 .r loop ;

: test {: xc -- :}
    xc xemit xc 6 .r xc pad xc!+ pad tuck - ( c-addr u )
    2dup showbytes drop xc@+ xc <> abort" test failed" drop cr ;

hex
$41 test $f6 test $416 test $20ac test $1d11e test
\ can also be written as
\ 'A' test 'ö' test 'Ж' test '€' test '𝄞' test
