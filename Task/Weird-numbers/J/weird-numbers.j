factor=: [: }: [: , [: */&> [: { [: <@(^ i.@>:)/"1 [: |: __&q:

classify=: 3 : 0
 weird =: perfect =: deficient =: abundant =: i. 0
 a=: (i. -. 0 , deficient =: 1 , i.&.:(p:inv)) y NB. a are potential semi-perfect numbers
 for_n. a do.
  if. n e. a do.
   factors=. factor n
   sf =. +/ factors
   if. sf < n do.
    deficient =: deficient , n
   else.
    if. n < sf do.
     abundant=: abundant , n
    else.
     perfect =: perfect , n
     a =: a -. (2+i.)@<.&.(%&n) y  NB. remove multiples of perfect numbers
     continue.
    end.
    NB. compute sums of subsets to detect semiperfection
    NB. the following algorithm correctly finds weird numbers less than 20000
    NB. remove large terms necessary for the sum to reduce the Catalan tally of sets
    factors =. /:~ factors  NB. ascending sort
    NB. if the sum of the length one outfixes is less n then the factor is required in the semiperfect set.
    i_required =. n (1 i.~ (>(1+/\.]))) factors
    target =. n - +/ i_required }. factors
    t =. i_required {. factors
    NB. work in chunks of 2^16 to reduce memory requirement
    sp =. target e. ; (,:~2^16) <@([: +/"1 t #~ (_ ,(#t)) {. #:);.3 i. 2 ^ # t
    if. sp do.
     a =: a -. (2+i.)@<.&.(%&n) y  NB. remove multiples of semi perfect numbers
    else.
     weird =: weird , n
     a =: a -. n
    end.
   end.
  end.
 end.
 a =: a -. deficient
 weird
)
