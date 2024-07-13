### Generic functions

# Set .popped to the first item of the specified array, and remove it therefrom
@ Usage example: {a:[1,2]} | pop(.a; .x)
def pop(array; popped):
  popped = array[0]
  | array |= .[1:];

# like while/2 but emit the final term rather than the first one
def whilst(cond; update):
  def _whilst:
    if cond then update | (., _whilst) else empty end;
  _whilst;

# Output: a prn in range(0;.)
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


### War Card Game
def suits: ["♣", "♦", "♥", "♠"];
def faces: ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" ];

def cards: [range( 0; 52) | "\(faces[.%13])\(suits[(./13)|floor])"];
def ranks: [range( 0; 52) | . % 13];

def war:
  cards as $cards
  | ranks as $ranks
  | ([range(0; 52)] | knuthShuffle) as $deck
  | reduce range(0; 26) as $i ({};
        .hand1 |= [$deck[2*$i]] + .
      | .hand2 |= [$deck[2*$i+1]] + .)
  | .numPlayed=0
  | whilst( .numPlayed == 0 and
            (.hand1|length) > 0 and (.hand2|length) > 0;

          pop(.hand1; .card1)
        | pop(.hand2; .card2)
        | .played1 = [.card1]
        | .played2 = [.card2]
        | .numPlayed = 2
        | whilst(.numPlayed > 0 ;
            .emit = "\($cards[.card1])\t\($cards[.card2])\t"
            | if $ranks[.card1] > $ranks[.card2]
              then .hand1 += .played1 + .played2
              | .emit += "Player 1 takes the \(.numPlayed) cards. Now has \(.hand1|length)."
              | .numPlayed = 0

              elif $ranks[.card1] < $ranks[.card2]
              then .hand2 += .played2 + .played1
              | .emit += "Player 2 takes the \(.numPlayed) cards. Now has \(.hand2|length)."
              | .numPlayed = 0

              else .emit += "War!\n"
              | if (.hand1|length) < 2
                then .emit +=  "Player 1 has insufficient cards left."
                | .hand2 = .hand2 + .played2 + .played1 + .hand1
                | .hand1 = []
                | .numPlayed = 0

                elif .hand2|length < 2
                then .emit += "Player 2 has insufficient cards left."
                | .hand1 = .hand1 + .played1 + .played2 + .hand2
                | .hand2 = []
                | .numPlayed = 0

                else
                  pop(.hand1; .card1)                    # face down card
                | .played1 += [.card1]

                | pop(.hand1; .card1)                    # face up card
                | .played1 += [.card1]

                | pop( .hand2; .card2)                   # face down card 2
                | .played2 += [.card2]

                | pop(.hand2; .card2)                    # face up card 2
                | .played2 += [.card2]

                | .numPlayed += 4
                | .emit += "? \t?\tFace down cards."
                end
              end
          )
    )
    | .emit,
      (if .hand1|length == 52
       then "Player 1 wins the game!"
       elif .hand2|length == 52
       then "Player 2 wins the game!"
       else empty
       end) ;

war
