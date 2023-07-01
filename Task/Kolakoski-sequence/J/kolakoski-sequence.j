NB. cyclic

create_cycle_=: 3 :0
 I=: 0
 A=: y
 N=: # A
)

next_cycle_=: 3 :0
 r=. A {~ N | I
 I=: >: I
 r
)

NB. kolakoski

kolakoski =: 30&$: :(dyad define) NB. TERMS kolakoski ALPHABET
 c=. y conew'cycle'
 s=. i. 0
 term=. 0
 while. x > # s do.
  s=. (, ([: #~ next__c)`(term&{ # next__c)@.(term < #)) s
  term=. >: term
 end.
 s
)


test=: (({.~ #) -: ]) }:@:(#;.1~ (1 , 2&(~:/\)))
