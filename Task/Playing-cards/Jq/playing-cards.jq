# Uncomment for gojq:
# def _nwise($n):
#  def nw: if length <= $n then . else .[0:$n] , (.[$n:] | nw) end;
#  nw;

# Output: a prn in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
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

def Pip: ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];

def Suit: ["♦", "♣", "♥", "♠"];

def Card(pip; suit): pip + suit;

def Deck: Card(Pip[]; Suit[]);

# Deal one round of the cards in .deck to the players
# represented by .hands,
# but if there are not enough cards, do nothing except add .error to the input
# Input {deck, hands}
def deal:
  (.hands | length) as $nplayers
  | if $nplayers > (.deck|length) then .error = "not enough cards"
    else reduce range(0;$nplayers) as $i (.; .hands[$i] += [.deck[$i]])
    | .deck |= .[$nplayers:]

# Deal $n cards to $nplayers players if there are enough cards in the input deck
# Input: a deck
# Output: {deck, hands}
def deal($n; $nplayers):
  if $n * $nplayers > length then "deal/2: not enough cards" | error
  else {deck: ., hands: [range(0; $nplayers)|[]]}
  | until( .hands[0]|length == $n; deal)
  end ;

# display an entire deck or else just the cards
def display:
  if length == 52 then _nwise(13) | join(" ")
  else join(" ")
  end;

def task:
  Deck
  | "After creation, the deck consists of:", display, "",
    (knuthShuffle
     | "After shuffling:", display, "",
       ( deal(5; 4)
         | "After dealing 5 cards each to 4 players, the hands are:",
         (.hands[] | display), "", "... leaving \(.deck|length)  cards") ) ;

task
