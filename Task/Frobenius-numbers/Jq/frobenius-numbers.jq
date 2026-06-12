# Generate a stream of Frobenius numbers up to an including `.`;
# specify `null` or `infinite` to generate an unbounded stream.
def frobenius:
  . as $limit
  | label $out
  | foreach (range(3;infinite;2) | select(is_prime)) as $p ({prev: 2};
       (.prev * $p - .prev - $p) as $frob
       | if ($limit != null and $frob > $limit) then break $out
         else .frob = $frob
         end
       | .prev = $p;
      .frob);

9999 | frobenius
