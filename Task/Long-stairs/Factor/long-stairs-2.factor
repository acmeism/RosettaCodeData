USING: combinators.random effects.parser io kernel math
math.order parser prettyprint stack-checker words ;

<< SYNTAX: .: [ scan-new-word parse-definition dup infer ]
    with-definition define-declared ; >>

.: position  0 ;
.: stairs    100 ;
.: new       position stairs ;
.: incd      swap 1 + swap ;
.: seconds   100 - 5 / ;
.: window?   seconds 600 609 between? ;
.: zap       2dup / [ incd ] whenp 1 + ;
.: barrage   5 [ zap ] times ;
.: .n        pprint 7 [ bl ] times ;
.: .stats    dup seconds .n over .n swap - .n nl ;
.: .header   "Seconds  behind     ahead" print ;
.: ?.status  dup window? [ 2dup .stats ] when ;
.: tick      incd barrage ;
.: demo      tick ?.status ;
.: first     new [ 2dup < ] [ demo ] while drop ;
.: sim       new [ 2dup < ] [ tick ] while drop ;
.: sims      0 first + 9999 [ sim + ] times ;
.: steps     "Avg. steps: " write 10000 / dup . ;
.: time      "Avg. seconds: " write seconds . ;
.: main      .header sims nl steps time ;

main
