USING: accessors kernel math.statistics prettyprint sequences
sequences.deep source-files vocabs words ;

"resource:core/sequences/sequences.factor" "sequences"
[ path>source-file top-level-form>> ]
[ vocab-words [ def>> ] [ ] map-as ] bi* compose [ word? ]
deep-filter sorted-histogram <reversed> 7 head .
