def squares_for_which_successor_is_prime:
  (. // infinite) as $limit
  | {i:1, sq: 1}
  | while( .sq < $limit; .i += 1 | .sq = .i*.i)
  | .sq
  | select((. + 1)|is_prime) ;

1000 | squares_for_which_successor_is_prime
