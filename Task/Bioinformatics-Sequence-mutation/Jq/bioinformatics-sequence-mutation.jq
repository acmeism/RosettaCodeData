### Generic utilities

# Output: a PRN in range(0; .)
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# Emit a stream of the constituent characters of the input string
def chars: explode[] | [.] | implode;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Print $n-character segments at a time, each prefixed by a 1-based index
def pretty_nwise($n):
  (length | tostring | length) as $len
  | def _n($i):
      if length == 0 then empty
      else "\($i|lpad($len)):  \(.[:$n])",
           (.[$n:] | _n($i+$n))
      end;
  _n(1);

### Biology
def bases: ["A", "C", "G", "T"];

def randomBase:
  bases | .[length|prn];

# $w is an array [weightSwap, weightDelete, weightInsert]
# specifying the weights out of 300 for each of swap, delete and insert
# Input: an object {dna}
# Output: an object {dna, message}
def mutate($w):

  def removeAt($p): .[:$p] + .[$p+1:];
  (.dna|length) as $le
  # get a random position in the dna to mutate
  | ($le | prn) as $p
  # get a random number between 0 and 299 inclusive
  | (300 | prn) as $r
  | .dna |= [chars]
  | if $r < $w[0]
    then   # swap
       randomBase as $base
       | .message = "  Change @\($p) \(.dna[$p]) to \($base)"
       |  .dna[$p] = $base
    elif $r < $w[0] + $w[1]
    then   # delete
        .message = "  Delete @\($p) \(.dna[$p])"
        | .dna |= removeAt($p)
    else   # insert
        randomBase as $base
        | .message = "  Insert @\($p) \($base)"
        | .dna |= .[:$p] + [$base] + .[$p:]
    end
    | .dna |= join("") ;

# Generate a random dna sequence of given length:
def generate($n):
  [range(0; $n) | randomBase] | join("");

# Pretty print dna and stats.
def prettyPrint($rowLen):
  "SEQUENCE:", pretty_nwise($rowLen),
  ( bow(chars) as $baseMap
    | "\nBASE COUNT:",
       ( bases[] as $c | "    \($c): \($baseMap[$c] // 0)" ),
       "    ------",
       "    Σ: \(length)",
       "    ======\n"
  ) ;

# For displaying the weights
def pretty_weights:
  "  Change: \(.[0])\n  Delete: \(.[1])\n  Insert: \(.[2])";

# Arguments are length, weights, mutations
def task($n; $w; $muts ):
  generate($n)
  | . as $dna
  | prettyPrint(50),
    "\nWEIGHTS (0 .. 300):", ($w|pretty_weights),
    "\nMUTATIONS (\($muts)):",
    (reduce range(0;$muts) as $i ({$dna};
       mutate($w)
       | .emit += [.message] )
     | (.emit | join("\n")),
       "",
       (.dna | prettyPrint(50)) ) ;


task(250;            # length
    [100, 100, 100]; # use e.g. [0, 300, 0] to choose only deletions
    10               # mutations
    )
