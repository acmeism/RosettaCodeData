USING: grouping.extras io.encodings.utf8 io.files kernel
math.order math.parser math.vectors prettyprint sequences
splitting ;
IN: rosetta-code.maximum-triangle-path-sum

: parse-triangle ( path -- seq )
    utf8 file-lines [ " " split harvest ] map
    [ [ string>number ] map ] map ;

: max-triangle-path-sum ( seq -- n )
    <reversed> unclip-slice [ swap [ max ] 2clump-map v+ ]
    reduce first ;

"triangle.txt" parse-triangle max-triangle-path-sum .
