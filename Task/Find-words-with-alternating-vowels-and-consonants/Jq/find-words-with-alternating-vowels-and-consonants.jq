# input: an array
# output: if the $parity elements are all in $array then true, else false
def check($parity; $array):
  . as $in
  | all( range(0+$parity; length; 2); $in[.]|IN($array[]));

def alternating:
  def c: explode[0];

  ("aeiou" | explode) as $vowels
  | ([range("a"|c; ("z"|c)+1)] - $vowels)  as $consonants
  | inputs
  | select(length>9)
  | . as $word
  | explode
  | select(
      (check(0; $consonants) and check(1; $vowels)) or
      (check(1; $consonants) and check(0; $vowels)) )
  | $word ;

alternating
