# emit an array such that .[i] is i if i is Duffinian and false otherwise
def duffinianArray($limit):
   ($limit | primeSieve |  map(not))
   | .[1] = false
   | reduce range(2; $limit) as $i (.;
       if (.[$i]|not) then .
       else if ($i % 2) == 0 and ($i|isSquare|not) and (($i/2)|isSquare|not)
            then .[$i] = false
            else sum($i|divisors) as $sigmaSum
            | if gcd($sigmaSum; $i) != 1
	      then .[$i] = false
	      else .
	      end
	    end
        end  );

# Input: duffinianArray($limit)
# Output: an array of the corresponding Duffinians
def duffinians:
 . as $d
 | reduce range(1;length) as $i ([]; if $d[$i] then . + [$i] else . end);

# Input: duffinians
# Output: stream of triplets
def triplets:
  . as $d
  | range (2; length) as $i
  | select( $d[$i] and $d[$i-1] and $d[$i-2] )
  | [$i-2, $i-1, $i];

def withCount(s; $msg):
  foreach (s,null) as $x (0; .+1;
    if $x == null then "\($msg) \(.-1)" else $x end );

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# 167039 is the minimum integer that is sufficient to produce 50 triplets
duffinianArray(167039)
| "First 50 Duffinian numbers:",
  (duffinians[0:50] | _nwise(10) | map(lpad(4)) | join(" ") ),
  "\nFirst 50 Duffinian triplets:",
  withCount(limit(50;triplets); "\nNumber of triplets: ")
