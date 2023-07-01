factor=: 3 : 0                          NB. explicit
 'primes powers'=. __&q: y
 input_to_cartesian_product=. primes ^&.> i.&.> >: powers
 cartesian_product=. , { input_to_cartesian_product
 , */&> cartesian_product
)

factor=: [: , [: */&> [: { [: (^&.> i.&.>@>:)/ __&q: NB. tacit


proper_divisors=: [: }: factor
sum_of_proper_divisors=: +/@proper_divisors

candidates=: 5 , [: +: [: #\@i. >.@-:  NB. within considered range, all but one candidate are even.
spds=:([:sum_of_proper_divisors"0(#\@i.-.i.&.:(p:inv))@*:)f.  NB. remove primes which contribute 1
