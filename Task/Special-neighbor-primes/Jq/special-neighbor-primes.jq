# Assumes . > 2
def next_prime:
  first(range(.+2; infinite) | select(is_prime));

def specialNP($savePairs):
  . as $limit
  | {p1: 2, p2: 3}
  | until( .p2 >= $limit;
      if (.p1 + .p2 - 1 | is_prime)
      then .pcount += 1
      | if $savePairs then .neighbors = .neighbors + [[.p1, .p2]] else . end
      else .
      end
      | .p1 = .p2
      | .p2 = (.p1|next_prime)
      )
  | if $savePairs then {pcount, neighbors} else {pcount} end;

100|specialNP(true)
