Filter=: (#~`)(`:6)
assert 'ac' -: 1 0 1"_ Filter 'abc'

intersect=:-.^:2
assert 'ab' -: 'abc'intersect'razb'

odometer=: (4$.$.)@:($&1)
Note 'odometer 2 3'
0 0
0 1
0 2
1 0
1 1
1 2
)

common=: 0 e. ~:
assert common 1 2 1
assert -. common 1 2 3

o=: '123456789' {~ [: -.@:common"1 Filter odometer@:(#&9) NB. o is y unique digits, all of them

f=: ,:"1/&g~        	     NB. f computes a table of all numerators and denominators pairs

mask=: [: </~&i. #  	     NB. the lower triangle will become proper fractions

av=:  (([: , mask) # ,/)@:f  NB. anti-vulgarization

c=: [: common@:,/"2 Filter av NB. ensure common digit(s)

fac=: [: ([: common ,&:~.&:q:&:"./)"2 Filter c  NB. assure a common factor
NB. This common factor filter might be useful in a future fully tacit version of the program.

cancellation=: monad define
 NDL =. c y   NB. vector of literal numerator and denominator
 NB. retain reducible fractions
 ND =. ". NDL NB. integral version of NDL
 MASK=. ([: common ,&:~.&:q:/)"1 ND        NB. assure a common factor
 FRAC=. _2 x: MASK # ND  NB. division
 CANDIDATES=. MASK # NDL
 rat=. , 'r'&,
 result=. 0 3 $ a:
 for_i. i. # CANDIDATES do.
  fraction =. i { FRAC
  pair=. i { CANDIDATES
  for_d. intersect/ pair do.
   trial=. pair -."1 d
   if. fraction = _2 x: ". trial do.
    result =. result , (rat/pair) ; (rat/trial) ; d
   end.
  end.
 end.
 result
)
