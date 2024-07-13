### Generic utilities
def count(s): reduce s as $x (0; . + 1);

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;


### Pseuo-random numbers

# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def sample:
  if length == 0 # e.g. null or []
  then null
  else .[length|prn]
  end;

def knuthShuffle:
  length as $n
  | if $n <= 1 then .
    else {i: $n, a: .}
    | until(.i ==  0;
        .i += -1
        | (.i + 1 | prn) as $j
        | .a[.i] as $t
        | .a[.i] = .a[$j]
        | .a[$j] = $t)
    | .a
    end;


### Cards

def R: "R"; # 82 ASCII
def B: "B"; # 66 ASCII

# Create deck, half red, half black and shuffle it.
def deck:
  ([range(0;26)|R] + [range(0;26)|B]) | knuthShuffle;

# Deal from `deck` into three stacks: {black, red, discard}
def deal:
  deck as $deck
  | reduce range(0; 51; 2) as $i (.;
      if $deck[$i] == B
      then .black += [$deck[$i+1]]
      else .red   += [$deck[$i+1]]
      end
      | .discard  += [$deck[$i]] );

def proceed:
  def p: join(" ");

  (.red|length) as $lr
  | (.black|length) as $lb
  | (.discard|length) as $ld

  | def displayStacks($discard):
    "  Red    : \($lr|lpad(2)) cards -> \(.red|p)",
    "  Black  : \($lb|lpad(2)) cards -> \(.black|p)",
    (select($discard)
    | "  Discard: \($ld) cards -> \(.discard|p)") ;

  # Input: {red, black}
  def swap($n):
    . + { rp: ([range(0; $lr)] | knuthShuffle[0:$n] ),
          bp: ([range(0; $lb)] | knuthShuffle[0:$n]) }
    | reduce range(0;$n) as $i (.;
          .red[.rp[$i]] as $t
        | .red[.rp[$i]] = .black[.bp[$i]]
        | .black[.bp[$i]] = $t);

   def epilog:
     # Check that the number of black cards in the black stack equals
     # the number of red cards in the red stack:
       count(select(.red[] == R)) as $rcount
     | count(select(.black[] == B)) as $bcount
     | "\nThe number of red cards in the red stack     = \($rcount)",
         "The number of black cards in the black stack = \($bcount)",
        if $rcount == $bcount
        then "So the assertion is correct!"
        else "So the assertion is incorrect!"
        end;

  "After dealing the cards, the stacks are as follows:",
  displayStacks(true),
  # Swap the same, random, number of cards between the red and black stacks.
  ( (if $lr < $lb then $lr else $lb end) as $min
   | (($min - 1|prn) + 1) as $n
   | swap($n)
   | "\n\($n) card(s) are to be swapped.",
     "The respective zero-based indices of the cards to be swapped are:",
     "  Red    : \(.rp|map(lpad(3))|p)",
     "  Black  : \(.bp|map(lpad(3))|p)",
     "\nAfter swapping, the red and black stacks are as follows:",
     displayStacks(false),
     epilog ) ;

deal | proceed
