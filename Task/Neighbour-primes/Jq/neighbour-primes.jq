def next_prime:
  if . == 2 then 3
  else first(range(.+2; infinite; 2) | select(is_prime))
  end;

# (not actually used)
def is_neighbour_prime:
  is_prime and ((. * next_prime) + 2 | is_prime);

# The task, implemented using only `next_prime` for efficiency
{p: 2}
| while (.p < 500;
    (.p|next_prime) as $np
    | .emit = false
    | if (.p * $np) + 2 | is_prime
      then .emit = .p
      else .
      end
    | .p = $np )
    | select(.emit).emit
