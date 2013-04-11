pop        =: ( {.^:notnull  ;  }. )@: > @: ]  /
push       =: ( ''  ;  ,~ )& >  /
tell_atom  =: >& {.
tell_queue =: >& {:
is_empty   =: '' -: 1 tell_queue

make_empty =: a: , a: [ ]
onto       =: [ ; }.@]

notnull    =: 0 ~: #
