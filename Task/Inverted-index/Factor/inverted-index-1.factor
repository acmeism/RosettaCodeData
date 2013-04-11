USING: assocs fry io.encodings.utf8 io.files kernel sequences
sets splitting vectors ;
IN: rosettacode.inverted-index

: file-words ( file -- assoc )
    utf8 file-contents " ,;:!?.()[]{}\n\r" split harvest ;
: add-to-file-list ( files file -- files )
    over [ swap [ adjoin ] keep ] [ nip 1vector ] if ;
: add-to-index ( words index file -- )
    '[ _ [ _ add-to-file-list ] change-at ] each ;
: (index-files) ( files index -- )
   [ [ [ file-words ] keep ] dip swap add-to-index ] curry each ;
: index-files ( files -- index )
    H{ } clone [ (index-files) ] keep ;
: query ( terms index -- files )
    [ at ] curry map [ ] [ intersect ] map-reduce ;
