def emit_until(cond; stream): label $out | stream | if cond then break
$out else . end;

def primes:
  2, (range(3;infinite;2) | select(is_prime));

def is_substring(checkPrime):
  def isp: if . == "" then true else tonumber|is_prime end;
  (if checkPrime then is_prime else true end)
  and (tostring
       | . as $s
       | all(range(0;length) as $i | range($i; length+1) as $j | [$i,$j];
             $s[.[0]:.[1]]|isp ));

# Output an array of the substring primes less than or equal to `.`
def substring_primes:
  . as $n
  | reduce emit_until(. > $n; primes) as $p ( null;
     if $p | is_substring(false)
     then . += [$p]
     else .
     end );

# Input: an array of the substring primes less than or equal to 373.
# Output: any other substring primes.
# Comment: if there are any others, they would have to be constructed
# from the numbers in the input array, as by assumption it includes
# all substring primes less than 100.
def verify:
  . as $sp
  | range(0;length) as $i
  | range(0;length) as $j
  | ([$sp[$i, $j]] | map(tostring) | add | tonumber) as $candidate
  | if $candidate | IN($sp[]) then empty
    elif $candidate | is_substring(true) then $candidate
    else empty
    end;

500 | substring_primes
| "Verifying that the following are the only substring primes:",
  .,
  "...",
  ( [verify] as $extra
    | if $extra == [] then "done" else $extra end )
