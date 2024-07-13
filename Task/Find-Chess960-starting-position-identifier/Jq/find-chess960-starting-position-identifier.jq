### Generic functions

# Output: a stream of the characters (glyphs) of the input string
def chars: split("")[];

def count(s): reduce s as $x (0; .+1);

# Variant of index/1
def index($target; $offset):
  if $offset >= length then null
  else (.[$offset:]|index($target)) as $ix
  | if $ix then $ix + $offset
    else null
    end
  end;

### Chess:

def glyphs: "♜♞♝♛♚♖♘♗♕♔";

def letters: "RNBQKRNBQK";

def names: { "R": "rook", "N": "knight", "B": "bishop", "Q": "queen", "K": "king" };

# a map of glyphs to letters
def g2lMap:
  [glyphs,letters]
  | map(split(""))
  | transpose
  | map( {(.[0]): .[1]})
  | add;

# convert glyphs to letters
# Input: pieces (a string)
# Output: a string
def g2l:
  g2lMap as $g2lMap
  | reduce chars as $p (""; . + $g2lMap[$p] );

def ntable:
  { "01":0, "02":1, "03":2, "04":3, "12":4, "13":5, "14":6, "23":7, "24":8, "34":9 };

# Input: pieces, a string
def spid:
  # convert glyphs to letters
  g2l as $pieces
  # check for errors
  | last(
      if $pieces|length != 8 then "There must be exactly 8 pieces." | error end,
      ("KQ"|split("")[] as $one
       | if 1 != count( $pieces|chars | select(. == $one)) then "There must be one \(names[$one])" | error end),
      ("RNB" | split("")[] as $two
       | if 2 != count( $pieces|chars | select(. == $two)) then "There must be two \(names[$two])" | error end))
  | ($pieces | index("R")) as $r1
  | ($pieces | index("R"; $r1 + 1)) as $r2
  | ($pieces|index("K")) as $k
  | if ($k < $r1 or $k > $r2) then "The king must be between the rooks." | error end
  | ($pieces|index("B")) as $b1
  | ($pieces|index("B"; $b1 + 1)) as $b2
  | if (($b2 - $b1) % 2 == 0) then "The bishops must be on opposite color squares." | error end

  # compute SP_ID
  | ($pieces|sub("Q"; "")|gsub("B"; "")) as $piecesN
  | ($piecesN|index("N")) as $n1
  | ($piecesN|index("N"; $n1+1)) as $n2

  | ntable["\($n1)\($n2)"] as $N

  | ($pieces|gsub("B"; "")) as $piecesQ
  | ($piecesQ|index("Q")) as $Q
  | ("0246" | index($b1|tostring)) as $D
  | if $D == null
    then {D: ("0246"|index($b2|tostring)),
          L: ("1357"|index($b1|tostring)) }
    else {D: $D,
          L: ("1357"|index($b2|tostring))}
    end
  | 96*$N + 16*$Q + 4*.D + .L ;

# The task
"♕♘♖♗♗♘♔♖", "♖♘♗♕♔♗♘♖", "♜♛♞♝♝♚♜♞", "♜♞♛♝♝♚♜♞"
|  "\(.) or \(g2l) has SP-ID of \(spid)"
