sieve=: 3 :0
 NB. sieve y  returns a vector of y boxes.
 NB. In each box is an array of 2 columns.
 NB. The first column is the factor tally
 NB. and the second column is a number with
 NB. that many factors.
 NB. Rather than factoring, the algorithm
 NB. counts prime seive cell hits.
 NB. The boxes are not ordered by factor tally.
 range=. <. + i.@:|@:-
 tally=. y#0
 for_i.#\tally do.
  j=. }:^:(y<:{:)i * 1 range >: <. y % i
  tally=. j >:@:{`[`]} tally
 end.
 (</.~ {."1) (,. i.@:#)tally
)
