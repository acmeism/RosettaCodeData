# Output: [p,p+2,p+6] where p is prime
def prime_triplets:
  def pt: .[2] == .[1] + 4 and .[1] == .[0] + 2;
  def next: .[1:] + [first( range(.[2] + 2; infinite;2) | select(is_prime))];
  # prime the foreach with the first triplet
  foreach range(7; infinite; 2) as $i ([2,3,5]; next; select(pt) ) ;

emit_until(.[0] >= 5500; prime_triplets)
