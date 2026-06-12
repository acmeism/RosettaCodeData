USING: assocs fry grouping io io.encodings.ascii io.files kernel
make math random sequences splitting ;

: build-markov-assoc ( path n -- assoc )
    [ ascii file-contents " " split harvest ] dip 1 + clump
    H{ } clone tuck [ [ unclip-last swap ] dip push-at ] curry
    each ;

: first-word ( assoc -- next-key ) random concat unclip , ;

: next-word ( assoc key -- next-key )
    [ of random ] keep unclip , swap suffix ;

: markov ( path n #words -- )
    [ build-markov-assoc ] dip '[
        dup first-word _ [ dupd next-word ] times
    ] { } make 2nip " " join print ;

"alice_oz.txt" 3 200 markov
