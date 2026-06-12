# Emit [p1,p2] where p1 < p2 < . and the concatenation is prime
def concatenative_primes:
  primes
  | range(0;length) as $i
  | range($i+1;length) as $j
  | [.[$i], .[$j]], [.[$j], .[$i]]
  | select( map(tostring) | add | tonumber | is_prime);

[100 | concatenative_primes | join("||")]
| (nwise(10) | map(lpad(6)) | join(" "))
