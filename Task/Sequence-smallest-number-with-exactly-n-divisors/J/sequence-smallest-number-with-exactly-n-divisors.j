sieve=: 3 :0
 range=. <. + i.@:|@:-
 tally=. y#0
 for_i.#\tally do.
  j=. }:^:(y<:{:)i * 1 range >: <. y % i
  tally=. j >:@:{`[`]} tally
 end.
 /:~({./.~ {."1) tally,.i.#tally
)
