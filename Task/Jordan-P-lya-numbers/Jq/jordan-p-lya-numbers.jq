### Generic functions
# For gojq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# tabular print
def tprint(columns; wide):
  reduce _nwise(columns) as $row ("";
     . + ($row|map(lpad(wide)) | join(" ")) + "\n" );

# Input: an array
# Output: a stream of pairs [$x, $frequency]
# A two-level dictionary is used: .[type][tostring]
def frequencies:
  if length == 0 then empty
  else . as $in
  | reduce range(0; length) as $i ({};
     $in[$i] as $x
     | .[$x|type][$x|tostring] as $pair
     | if $pair
       then .[$x|type][$x|tostring] |= (.[1] += 1)
       else .[$x|type][$x|tostring] = [$x, 1]
       end )
  | .[][]
  end ;

# Output: the items in the stream up to but excluding the first for which cond is truthy
def emit_until(cond; stream): label $out | stream | if cond then break $out else . end;

### Jordan-Pólya numbers
# input: {factorial}
# output: an array
def JordanPolya($lim; $mx):
  if $lim < 2 then [1]
  else . + {v: [1], t: 1, k: 2}
  | .mx = ($mx // $lim)
  | until(.k > .mx or .t > $lim;
        .t *= .k
	| if .t <= $lim
          then reduce JordanPolya(($lim/.t)|floor; .t)[] as $rest (.;
                 .v += [.t * $rest] )
          | .k += 1
	  else .
	  end)
  | .v	
  | unique
  end;

# Cache m! for m <= $n
def cacheFactorials($n):
   {fact: 1, factorial: [1]}
   | reduce range(1; $n + 1) as $i (.;
       .fact *= $i
       | .factorial[$i] = .fact );

# input: {factorial}
def Decompose($n; $start):
  if $start and $start < 2 then []
  else
  { factorial,
    start: ($start // 18),
    m: $n,
    f: [] }
  | label $out
  | foreach range(.start; 1; -1) as $i (.;
        .i = $i
        | .emit = null
        | until (.emit or (.m % .factorial[$i] != 0);
            .f += [$i]
            | .m = (.m / .factorial[$i])
            | if .m == 1 then .emit = .f else . end)
	| if .emit then ., break $out else . end)
  | if .emit then .emit
    elif .i == 2 then Decompose($n; .start-1)
    else empty
    end
  end;

# Input: {factorial}
# $v should be an array of J-P numbers
def synopsis($v):
  (100, 800, 1800, 2800, 3800) as $i
  | if $v[$i-1] == null
    then "\nThe \($i)th Jordan-Pólya number was not found." | error
    else "\nThe \($i)th Jordan-Pólya number is \($v[$i-1] )",
          ([Decompose($v[$i-1]; null) | frequencies]
           | map( if (.[1] == 1) then "\(.[0])!"  else "(\(.[0])!)^\(.[1])" end)
           | "  i.e. " + join(" * ") )
    end ;

def task:
  cacheFactorials(18)
  | JordanPolya(pow(2;53)-1; null) as $v
  | "\($v|length) Jordan–Pólya numbers have been found. The first 50 are:",
    ( $v[:50] | tprint(10; 4)),
    "\nThe largest Jordan–Pólya number before 100 million: " +
    "\(if $v[-1] > 1e8 then last(emit_until(. >= 1e8; $v[])) else "not found" end)",
    synopsis($v) ;

task
