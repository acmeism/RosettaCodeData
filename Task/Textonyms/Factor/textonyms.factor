USING: assocs assocs.extras interpolate io io.encodings.utf8
io.files kernel literals math math.parser prettyprint sequences
unicode ;

<< CONSTANT: src "unixdict.txt" >>

CONSTANT: words
    $[ src utf8 file-lines [ [ letter? ] all? ] filter ]

CONSTANT: digits "22233344455566677778889999"

: >phone ( str -- n )
    [ CHAR: a - digits nth ] map string>number ;

: textonyms ( seq -- assoc )
    [ [ >phone ] keep ] map>alist expand-keys-push-at ;

: #textonyms ( assoc -- n )
    [ nip length 1 > ] assoc-filter assoc-size ;

words length src words textonyms [ assoc-size ] keep #textonyms

[I There are ${} words in ${} which can be represented by the digit key mapping.
They require ${} digit combinations to represent them.
${} digit combinations represent Textonyms.I] nl nl

"7325 -> " write words textonyms 7325 of .
