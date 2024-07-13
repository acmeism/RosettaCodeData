# Source of entropy
include "MRG32k3a" {search: "."}; # see above

### General utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def array_swap($i; $j):
  if $i < $j then array_swap($j;$i)
  elif $i == $j then .
  else .[$i] as $t
  | .[:$j] + [$t] + .[$j:$i] + .[$i + 1:]
  end ;

# input: array of length $n
def shuffle:
  length as $n
  | ($n | prn($n)) as $prn
  # First cut the deck
  | .[$prn[0]:] + .[:$prn[0]]
  | reduce range(0; $n - 1) as $i (.;
       array_swap($prn[$i]; $prn[$i+1]) ) ;


### The Set Game

# For the standard Set game:
def attributes: ["Color", "Symbol", "Number", "Shading"];
def number_of_values: 3;

# a single card
def toString:
  [attributes, .] | transpose
  | map(join(": ")|lpad(7))
  | join("  ");

# Create a deck for which each attribute defined by `attributes` has $j possible values:
def createDeck($j):
  (attributes|length) as $k
  | [range(0;$j)]
  | [combinations($k)];

def isSet:
  . as $trio
  | all( range(0; attributes|length);
         . as $i | $trio | map(.[$i]) | unique | length | IN(1,number_of_values));

# For the standard Set game
# For "advanced" play, set $advanced == true
def playGame( $advanced ):
  (if $advanced then 12 else 9 end) as $nCards
  | (($nCards/2)|floor) as $nSets
  | {sets: [],  deck: createDeck(number_of_values) }
  | label $out
  | foreach range(0; infinite) as $_ (.;
      .deck |= shuffle
      | .sets = []
      | foreach range(0; $nCards-2) as $i (.;
          foreach range($i+1; $nCards-1) as $j (.;
            foreach range($j+1; $nCards) as $k (.;
              [.deck[$i], .deck[$j], .deck[$k]] as $trio
              |  if $trio | isSet
                 then .sets += [$trio]
                 | if (.sets|length) >= $nSets
                   then .emit = true, break $out
                   end
                 end ) ) ) )
  | select(.emit)
  | (.deck[0:$nCards] | sort) as $hand
  | "DEALT \($nCards) CARDS:",
    ($hand[]|toString),
    "\nCONTAINING \($nSets) SETS:",
    (.sets
     | sort[]
     | ((.[] | toString),"") ), "" ;

playGame(false, true)
