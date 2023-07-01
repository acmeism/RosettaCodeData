# Input: a string
# Output: an array, being the exploded form of the normalized input
def normalize:
  explode
  | map(if . >= 97 then (. - 97) elif . >= 65 then (. - 65) else empty end);

# Input: an array of strings
# Output: a dictionary with key:value pairs: normalizedString:string
def dictionary:
  reduce .[] as $s ( {}; . + { ($s|normalize|implode): $s });

# Input: an array of strings (e.g. state names)
# Output: a stream of solutions
def solve:

  # Given a pair of normalized state names as lists of integers:
  def nletters: map(length) | add;

  # input [[s1,s2], [t2,t2]]
  def solved:
    ( .[0] | add | sort) ==  (.[1] | add | sort);

  unique
  | length as $l
  | dictionary as $dictionary
  | ($dictionary | keys | map(explode)) as $states
  | reduce ( range(0; $l) as $s1
                 | range($s1+1; $l) as $s2
                 | range($s1+1; $l) as $t1
	         | select($s2 != $t1)
	         | range($t1+1; $l) as $t2
     	         | select($s2 != $t2)
	         | [[$states[$s1], $states[$s2]], [$states[$t1], $states[$t2]]] ) as $quad
       ([];
        if ($quad[0] | nletters) == ($quad[1] | nletters)
	   and ($quad | solved)
	then . + [$quad | map( map(  $dictionary[ implode ] ))]
	else .
	end)
  | .[];
