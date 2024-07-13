include "MRG32k3a" {search: "."};  # see comment above

### Generic functions

# Determine if stream is non-decreasing
def is_sorted(stream):
  first(foreach stream as $s ( null;
    if . == null or $s >= .[0] then [$s]
    else 0
    end;
    select(. == 0) ) )
  // 1
  | . == 1;

# Write to stderr
def inform(msg):
  . as $in
  | ("\(msg)\n" | stderr)
  | $in;

# q means quit
def read($prompt; $regex):
  def r:
    ($prompt | stderr | empty),
    (try ((input
          | if . == "q" then halt
            else select(test($regex))
            end) // r)
     catch if . == "break" then halt else r end );
  r;

# Returns levenshteinDistance(s1; $s2) <= $max
# A recursive algorithm is good enough if $max is small
def levenshteinDistance($s1; $s2; $max):
  def lev:
    . as [$s1, $s2, $max]
    | if   ($s1|length) == 0 then ($s2|length) <= $max
      elif ($s2|length) == 0 then ($s1|length) <= $max
      elif $s1[:1] == $s2[:1]
      then [$s1[1:], $s2[1:], $max] | lev
      else ($s1|length) <= $max
        or ($s2|length) <= $max
        or ([$s1[1:], $s2, $max-1] | lev)
        or ([$s1, $s2[1:], $max-1] | lev)
        or ([$s1[1:], $s2[1:], $max-1] | lev)
    end ;
  [$s1, $s2, $max] | lev;

##### The Wordiff Game

# Output: the sorted list of words
# The sort is skipped if we can readily determine the list is already sorted
def words:
  [$dict | splits(" *\n *")]
  | if is_sorted(.[]) then .
    else sort
    end;

def player1: read("Player 1, please enter your name : "; ".");
def player2: read("Player 2, please enter your name : "; ".");

def round:
  .words as $words
  | read("\(.player), enter your word: "; ".") as $word
  | ($word|length) as $len
  | .ok = false
  | if $len < 3
    then inform("Words must be at least three letters long.")
    elif $word == .prevWord
    then  inform("You must change the previous word.")
    elif .used[$word]
    then inform("The word \"\($word)\" has been used before.")
    elif # not in dictionary
         # if $words is not sorted:  ($word | IN($words[]) | not)
         # binary search:
         ($words | bsearch($word) < 0)
    then inform("Not in dictionary.")

    elif levenshteinDistance($word; .prevWord; 1)
    #### Good to go
    then .ok = true
    | .prevLen = ($word|length)
    | .prevWord = $word
    | .used[$word] = true
    | .player = (if .player == .player1 then .player2 else .player1 end)
    else inform("Sorry. Only one addition, deletion or alteration is allowed.")
    end
  | if (.ok|not) then inform("Please retry. The current word is: \(.prevWord)") end
  | round ;

def play:
  player1 as $player1
  | { player1: $player1,
      player2: ( player2 | if . == $player1 then . + "2" else . end)
    }
  | inform("Reading and perhaps sorting the list of words takes a few seconds... ")
  | inform("Meanwhile note that you can quit by entering q at a prompt.")
  | .words = words
  # Avoid storing the subset of words needed to make a random selection:
  | (.words | map(select(length | IN(3,4))) | .[length | prn(1)[]]) as $firstWord
  | .prevLen = ($firstWord|length)
  | .prevWord = $firstWord
  | .used = {($firstWord): true}  # a JSON object for efficiency
  | .player = .player1
  | "\nThe first word is: \($firstWord)",
     round;

play
