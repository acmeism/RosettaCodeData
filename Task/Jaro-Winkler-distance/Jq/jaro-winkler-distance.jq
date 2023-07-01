# See [[Jaro_similarity#jq]] for the implementation of jaro/2

def length_of_common_prefix($s1; $s2):
  if ($s1|length) > ($s2|length) then length_of_common_prefix($s2; $s1)
  else ($s1|explode) as $x1
  | ($s2|explode) as $x2
  | first( range(0;$x1|length) | select( $x1[.] != $x2[.] )) // ($x1|length)
  end;

# Output: the Jaro-WInkler distance using 0.1 as the common-prefix multiplier
def jaro_winkler($s1; $s2):
  if $s1 == $s2 then 0
  else jaro($s1; $s2) as $j
  | length_of_common_prefix($s1[:4]; $s2[:4]) as $l
  | 1 - ($j + 0.1 * $l * (1 - $j))
  end ;

# Input: an array of words
# Output: [[match, distance] ...]
def candidates($word; $threshold):
  map(jaro_winkler($word; . ) as $x | select($x <= $threshold) | [., $x] );

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task:
  [inputs] # the dictionary
  | ("accomodate", "definately", "goverment​", "occured", "publically", "recieve​", "seperate", "untill", "wich​") as $word
  | candidates($word; 0.15) | sort_by(.[-1]) | .[:5]
  | "Matches for \($word|lpad(10)): Distance",
    (.[] | "\(.[0] | lpad(21)) : \(.[-1] * 1000 | round / 1000)") ;

task
