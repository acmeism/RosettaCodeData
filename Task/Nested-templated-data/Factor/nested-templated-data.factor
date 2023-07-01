USING: formatting kernel literals math sequences sequences.deep ;
IN: rosetta-code.nested-template-data

CONSTANT: payloads $[ 7 <iota> [ "Payload#%d" sprintf ] map ]

: insert-payloads ( template -- data-structure )
    [ dup fixnum? [ payloads ?nth ] when ] deep-map ;

{ { { 1 2 }
    { 3 4 1 }
    5 } }

{ { { 1 2 }
    { 10 4 1 }
    5 } }

[ dup insert-payloads "Template: %u\nData Structure: %u\n"
printf ] bi@
