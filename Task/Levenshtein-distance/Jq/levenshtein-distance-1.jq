# lookup the distance between s and t in the nested cache,
# which uses basic properties of the Levenshtein distance to save space:
def lookup(s;t):
  if (s == t) then 0
  elif (s|length) == 0 then (t|length)
  elif (t|length) == 0 then (s|length)
  elif (s|length) > (t|length) then
       .[t] as $t | if $t then $t[s] else null end
  else .[s] as $s | if $s then $s[t] else null end
  end ;

# output is the updated cache;
# basic properties of the Levenshtein distance are used to save space:
def store(s;t;value):
  if (s == t) then .
  else (s|length) as $s | (t|length) as $t
    | if $s == 0 or $t == 0 then .
      elif $s < $t then .[s][t] = value
      elif $t < $s then .[t][s] = value
      else (.[s][t] = value) | (.[t][s] = value)
      end
  end ;

# Input is a cache of nested objects; output is [distance, cache]
def ld(s1; s2):

  # emit [distance, cache]
  # input: cache
  def cached_ld(s;t):
    lookup(s;t) as $check
    | if $check then [ $check, . ]
      else ld(s;t)
      end
  ;

  # If either string is empty,
  # then distance is insertion of the other's characters.
  if   (s1|length) == 0 then [(s2|length), .]
  elif (s2|length) == 0 then [(s1|length), .]
  elif (s1[0:1] == s2[0:1]) then
    cached_ld(s1[1:]; s2[1:])
  else
    cached_ld(s1[1:]; s2) as $a
    | ($a[1] | cached_ld(s1; s2[1:])) as $b
    | ($b[1] | cached_ld(s1[1:]; s2[1:])) as $c
    | [$a[0], $b[0], $c[0]] | (min + 1) as $d
    | [$d, ($c[1] | store(s1;s2;$d)) ]
  end ;

def levenshteinDistance(s;t):
  s as $s | t as $t | {} | ld($s;$t) | .[0];
