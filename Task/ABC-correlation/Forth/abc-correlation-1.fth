variable #a   variable #b   variable #c
: 1+!   1 swap +! ;
: init   0 #a ! 0 #b ! 0 #c ! ;
: for/chars   chars over + swap ;
: ?count   rot c@ rot = if 1+! else drop then ;
: ?a   [char] a #a ?count ;
: ?b   [char] b #b ?count ;
: ?c   [char] c #c ?count ;
: equal?   #a @ #b @ = #b @ #c @ = and ;
: countabc   init for/chars do i ?a i ?b i ?c loop equal? ;
