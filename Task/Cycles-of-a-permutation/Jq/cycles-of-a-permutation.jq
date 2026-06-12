### Generic utility functions

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def count(s): reduce s as $i (0; . + 1);

# Least common multiple
def lcm($m; $n):
  # Define the helper function to take advantage of jq's tail-recursion optimization
  def _lcm:
    # state is [m, n, i]
    if (.[2] % .[1]) == 0 then .[2] else (.[0:2] + [.[2] + $m]) | _lcm end;
  [$m, $n, $m] | _lcm;

# Rotate an array $n places to the left assuming 0 <= $n < length
def rotateLeft($n):
  .[$n:] + .[:$n];

def days:    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

### Cycles of a Permutation

# Arrange a cycle so the least element is first.
def smallestFirst:
  . as $cycle
  | reduce range(1; length) as $i ( {min: .[0], minIx: 0};
            if $cycle[$i] < .min
            then .min = $cycle[$i]
            | .minIx = $i
            end )
   | .minIx as $minIx
   | $cycle | rotateLeft($minIx) ;

# Converts a list in one-line notation to a space-separated string.
def oneLineToString: join(" ");

# Converts a list in cycle notation to a string where each cycle is space-separated
# and enclosed in parentheses.
def cyclesToString:
   map( "(" + join(" ") + ")" ) | "[" + join(" ") + "]";

# Returns a list in one-line notation derived from two equal-length strings s and t.
def oneLineNotation($s; $t):
  ($s|length) as $len
  | reduce range(0; $len) as $i ([]; .[$i] = ($s|index($t[$i:$i+1])) + 1)
  | {i: ($len-1), res: .}
  | until( .i == -1;
       if .res[.i] != .i + 1
       then .i=-1
       else .i as $i
       | .res |= del(.[$i])
       | .i += -1
       end )
  | .res ;

 # Returns a list in cycle notation derived from two equal-length strings s and t.
def cycleNotation($s; $t):
  { used: [range(0; $s|length) | false],
    cycles: [] }
  | reduce range(0; $s|length) as $i (.;
      if .used[$i] then .
      else .cycle = []
      | .used[$i] = true
      | .ix = ($t|index($s[$i:$i+1]))
      | if $i == .ix then .
        else .cycle += [$i+1]
        | .done = false
        | until (.done;
               .cycle += [.ix + 1]
               | .used[.ix] = true
               | .ix as $j
               | .ix = ($t|index($s[$j:$j+1]))
               | if .cycle[0] == .ix + 1
                 then .cycles += [.cycle | smallestFirst ]
                 | .done = true
                 else .
                 end )
        end
      end )
     | .cycles ;

# Converts a list in one-line notation to its inverse
# assuming $targetLength specifies the full length
def oneLineInverse($targetLength):
  . as $oneLine
  | length as $c
  | {s: (map(. + 64) | implode) }
  | if $c < $targetLength
    then reduce range($c; $targetLength + 1) as $i (.;
           .s += ([$c + 65]|implode) )
    end
  | ([range(0; $targetLength) | . + 65] | implode) as $t
 | oneLineNotation(.s; $t) ;

# Converts a list of cycles to its inverse.
def cycleInverse:
  map(reverse | smallestFirst) ;

# Permutes input string using perm in one-line notation.
def oneLinePermute($perm):
  . as $s
  | ($perm|length) as $c
  | reduce range(0; $c) as $i ({t:[]};
      ($perm[$i]-1) as $j
      | .t[$i] = $s[$j:$j+1] )
  | (.t | join(""))
    +  if $c < ($s|length)
       then $s[$c:]
       else ""
       end ;

# Permutes input string in accordance with the permutation specified
# by $cycles
def cyclePermute($cycles):
  . as $s
  | reduce $cycles[] as $cycle ( [];
       reduce range(0;$cycle|length-1) as $i (.;
          ($cycle[$i]-1) as $j
          | .[$cycle[$i+1]-1] = $s[$j:$j+1] )
       | ($cycle[-1]-1) as $j
       | .[$cycle[0]-1] = $s[$j:$j+1] )
   | reduce range(0; $s|length) as $i (.;
       if .[$i] == null then .[$i] = $s[$i:$i+1] end)
   | join("") ;

# Returns a single permutation in cycle notation resulting from applying
# $cycles1 first and then $cycles2.
def cycleCombine($cycles1; $cycles2; $targetLength):
  {s: ([range(0; $targetLength) | . + 65] | implode)}
  | .t = (.s | cyclePermute($cycles1))
  | .t |= cyclePermute($cycles2)
  | cycleNotation(.s; .t);

# Converts a list in one-line notation to cycle notation relative to $targetLength
def oneLineToCycle($targetLength):
  . as $oneLine
  | length as $c
  | { t: ($oneLine | map(. + 64) | implode) }
  | if $c < $targetLength
    then reduce range($c; $targetLength+1) as $i (.;  ## ??
       .t += ([$c + 65]|implode) )  ## ??
    end
  | ([range (0; $targetLength) | . + 65] | implode) as $s
  | cycleNotation($s; .t);

# Converts a list in cycle notation to one-line notation.
def cycleToOneLine($targetLength):
  . as $cycles
  | ([range(0; $targetLength) | . + 65 ] | implode)
  | cyclePermute($cycles) as $t
  | oneLineNotation(.; $t);

# The order of a permutation specified by its cycles
def order:
  def lcm: reduce .[] as $x (1; lcm(.; $x));
  map(length) | lcm;

# Returns the signature of a permutation specified by its cycles
def signature:
  count(.[] | select(length % 2 == 0))
  | if . % 2 == 0 then 1 else -1 end ;


### The task at hand
def letters: [
    "HANDYCOILSERUPT",  # Monday
    "SPOILUNDERYACHT",  # Tuesday
    "DRAINSTYLEPOUCH",  # Wednesday
    "DITCHSYRUPALONE",  # Thursday
    "SOAPYTHIRDUNCLE",  # Friday
    "SHINEPARTYCLOUD",  # Saturday
    "RADIOLUNCHTYPES"   # Sunday
];

def cycles:  cycleNotation(letters[2]; letters[3]);

def prev:    "STOREDAILYPUNCH";

cycles
| .                                              as $cycles
| (letters[0] | length)                          as $targetLength
| cycleToOneLine($targetLength)                  as $oneLine
| ($oneLine | oneLineInverse($targetLength))     as $oneLine2
| cycleNotation(letters[3]; letters[4])          as $cycles3
| cycleCombine($cycles; $cycles3; $targetLength) as $cycles4

| "On Thursdays Alf and Betty should rearrange their letters using these cycles:",
  cyclesToString,
  "So that \(letters[2]) becomes \( letters[2] | cyclePermute($cycles) )",
  "\nOr they could use the one-line notation:",
  ($oneLine | oneLineToString),
  "\nTo revert to the Wednesday arrangement they should use these cycles:",
  (cycleInverse | cyclesToString),
  "\nOr with the one-line notation:",
  ($oneLine2|oneLineToString),
  "So that \(letters[3]) becomes \( letters[3] | oneLinePermute($oneLine2))",

  "\nStarting with the Sunday arrangement and applying each of the daily arrangements",
  "consecutively, the arrangements will be:",
  "\n     \(letters[6])\n",
  (range(0; days|length) as $j
   | (if $j == (days|length) - 1 then "" else empty end),
     days[$j] + ": " +
     ( (if $j == 0 then (days|length-1) else $j - 1 end) as $i
       | oneLineNotation(letters[$i]; letters[$j]) as $ol
       | letters[$i] | oneLinePermute($ol))),

"\nTo go from Wednesday to Friday in a single step they should use these cycles:",
($cycles4|cyclesToString),
"So that \(letters[2]) becomes \( letters[2] | cyclePermute($cycles4))",

"\nThese are the signatures of the permutations:",
(days | join(" ")),
([ range(0; days|length) as $j
  | (if  $j == 0 then 6 else $j - 1 end) as $i
  | (cycleNotation(letters[$i]; letters[$j]) | signature)
  | tostring | lpad(3) ] | join(" ")
),

"\nThese are the orders of the permutations:",
(days |join(" ")),
([ range( 0; days|length) as $j
  | (if  $j == 0 then 6 else $j - 1 end) as $i
  | cycleNotation(letters[$i]; letters[$j]) | order]
 | map(lpad(3)) | join(" ")),

"\nApplying the Friday cycle to a string 10 times:",
( foreach range (0;11) as $i ( {prev: prev};
     .emit = "\($i | lpad(2))  \(.prev)"
     | .prev |= cyclePermute($cycles3) )
  | .emit )
