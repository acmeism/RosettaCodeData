USING: arrays ascii formatting kernel math math.functions
math.order sequences ;
IN: rosetta-code.vigenere-cipher

: mult-pad ( key input -- x )
    [ length ] bi@ 2dup < [ swap ] when / ceiling ;

: lengthen-pad ( key input -- rep-key input )
    [ mult-pad ] 2keep [ <repetition> concat ] dip
    [ length ] keep [ head ] dip ;

: normalize ( str -- only-upper-letters )
    >upper [ LETTER? ] filter ;

: vigenere-encrypt ( key input -- ecrypted )
    [ normalize ] bi@ lengthen-pad
    [ [ CHAR: A - ] map ] bi@ [ + 26 mod CHAR: A + ] 2map ;

: vigenere-decrypt ( key input -- decrypted )
    [ normalize ] bi@ lengthen-pad [ [ CHAR: A - ] map ] bi@
    [ - 26 - abs 26 mod CHAR: A + ] 2map ;

: main ( -- )
    "Vigenere cipher" dup
    "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
    2dup "Key: %s\nInput: %s\n" printf
    vigenere-encrypt dup "Encrypted: %s\n" printf
    vigenere-decrypt "Decrypted: %s\n" printf ;

MAIN: main
