def count(s): reduce s as $i (0;.+1);

def swap($i;$j):
  .[$i] as $x | .[$i] = .[$j] | .[$j] = $x;

# Input: an array
# Output: a best shuffle
def bestShuffleArray:
  . as $s
  | reduce range(0; length) as $i (.;
      . as $t
      | (first(range(0; length)
               | select( $i != . and
                         $t[$i] != $s[.] and
                         $s[$i] != $t[.] and
                         $t[$i] != $t[.])) as $j
         | swap($i;$j))
	 // $t  # fallback
    );

# Award 1 for every spot which changed:
def score($base):
  . as $in
  | count( range(0;length)
           | select($base[.] != $in[.]) );

# Input: a string
# Output: INPUT, BESTSHUFFLE, (NUMBER)
def bestShuffle:
  . as $in
  | explode
  | . as $s
  | bestShuffleArray
  | "\($in), \(implode), (\( length - score($s) ))" ;
