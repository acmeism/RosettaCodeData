### Preliminaries
# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
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

### Riffle
# input: deck
def riffle(iterations):
  ((length / 2)|floor) as $mid
  | {pile: .}
  | reduce range(0; iterations) as $i (.;
      (($mid / 10)|floor) as $tenpc
      # choose a random number within 10% of midpoint
      | ($mid - $tenpc + ((2 * $tenpc + 1)|prn)) as $cut
      # split deck into two at cut point
      | .deck1 = .pile[0:$cut]
      | .deck2 = .pile[$cut:]
      | .pile = []
      # choose to draw from top or bottom
      | ((2|prn) == 1) as $fromTop
      | until( (.deck1|length) == 0 or (.deck2|length) == 0;
          if $fromTop
          then .deck1[0] as $card
          | .deck1 |= .[1:]
          | .pile += [$card]
          | .deck2[0] as $card
          | .deck2 |= .[1:]
          | .pile += [$card]
          else .deck1[-1] as $card
          | .deck1 |= .[:-1]
          | .pile += [$card]
          | .deck2[-1] as $card
          | .deck2 |= .[:-1]
          | .pile += [$card]
          end )
      # add any remaining cards to the pile and reverse it
      | if (.deck1|length > 0)
        then .pile += .deck1
        elif (.deck2|length > 0)
        then .pile += .deck2
        else .
        end
      | .pile |= reverse # as pile is upside down
     )
  | .pile;

### Overhand
# input: deck
def overhand(iterations):
  ((length / 5)|floor) as $twentypc
  | { pile: .,
      pile2: [] }
  | reduce range(0; iterations) as $i (.;
      until (.pile|length == 0;
         ([(.pile|length), (1 + ($twentypc|prn))] | min) as $cards
         | .pile2 = .pile[0:$cards] + .pile2
         | .pile |= .[$cards:]
      | .pile += .pile2
      | .pile2 = [] )
  | .pile ;

### Example
def deck: [range(1;21)];

def iterations: 10;

deck
| "Starting deck:",
  "Riffle shuffle with \(iterations) iterations:",
  riffle(iterations),
  "\nOverhand shuffle with \(iterations) iterations:",
  overhand(iterations),
  "\nStandard library shuffle with 1 iteration:",
  knuthShuffle
