import: parallel

: testSequence
| s i |
   Sequence new(0) ->s
   100 loop: i [ #[ s nextValue println ] & ] ;
