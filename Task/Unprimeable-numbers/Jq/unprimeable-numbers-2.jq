def variants:
  digits
  | range(0; length) as $pos
  | range(0;10) as $newdigit
  | if .[$pos] == $newdigit then empty
    else .[$pos] = $newdigit
    | join("")|tonumber
    end;

def is_unprimeable:
  if is_prime or any(variants; is_prime) then false
  else true
  end;

def unprimeables:
  range(4; infinite) | select(is_unprimeable);
