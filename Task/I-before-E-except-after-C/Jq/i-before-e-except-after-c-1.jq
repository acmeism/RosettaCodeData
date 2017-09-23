def plausibility_ratio: 2;

# scan/2 produces a stream of matches but the first match of a segment (e.g. cie)
# blocks further matches with that segment, and therefore if scan produces "ie",
# it was NOT preceded by "c".
def dictionary:
  reduce .[] as $word
    ( {};
      reduce ($word | scan("ie|ei|cie|cei")) as $found ( .; .[$found] += 1 ));

def rules:
  { "I before E when not preceded by C": ["ie",  "ei"],
    "E before I when preceded by C":     ["cei", "cie"]
   };

# Round to nearest integer or else "round-up"
def round:
  if . < 0 then (-1 * ((- .) | round) | if . == -0 then 0 else . end)
  else floor as $x | if (. - $x) < 0.5 then $x else $x+1 end
  end;

def assess:
  (split("\n") | dictionary) as $dictionary
  | rules as $rules
  | ($rules | keys[]) as $key
  | $rules[$key] as $fragments
  | $dictionary[$fragments[0]] as $x
  | $dictionary[$fragments[1]] as $y
  | ($x / $y) as $ratio
  | (if $ratio > plausibility_ratio then "plausible"
     else "implausible" end) as $plausibility
  | " -- the rule \"\($key)\" is \($plausibility)
    as ratio = \($x)/\($y) ~ \($ratio * 100 |round)%"  ;

"Using the problematic criterion specified in the task requirements:", assess
