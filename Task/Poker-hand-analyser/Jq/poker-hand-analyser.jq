# A card is represented by a JSON object:
def Card($face; $suit): {$face, $suit};

def FACES: "23456789tjqka";
def SUITS: "shdc";

# Input: an array of Card
def isStraight:
  sort_by(.face)
  | (.[0].face + 4 == .[4].face)
    or (.[4].face == 14 and .[0].face == 2 and .[3].face == 5) ;

def isFlush:
  .[0].suit as $suit
  | all(.[]; .suit == $suit);

# Input: a string such as "2h 2d 2c kc qd"
def analyzeHand:
    (FACES | split("")) as $FACES
  | (SUITS | split("")) as $SUITS
  | ascii_downcase
  | split(" ")
  | unique
  | if length != 5 or
       any(length != 2 or
           (.[0:1] | IN($FACES[]) | not) or
           (.[1: ] | IN($SUITS[]) | not) )
    then "invalid"
    else [.[] as $s | Card(($FACES|index($s[0:1])) + 2; $s[1:]) ]
    | . as $cards
    | group_by(.face)
    | if length == 2
      then if any(length == 4) then "four-of-a-kind"
           else "full-house"
           end
      elif length == 3
      then if any(length == 3) then "three-of-a-kind"
           else "two-pairs"
           end
      elif length == 4
      then "one-pair"
      else ($cards|[isFlush, isStraight]) as [$flush, $straight]
      | if $flush and $straight then "straight-flush"
        elif $flush             then "flush"
        elif $straight          then "straight"
        else                         "high-card"
        end
      end
    end ;

def hands: [
    "2h 2d 2c kc qd",
    "2h 5h 7d 8c 9s",
    "ah 2d 3c 4c 5d",
    "2h 3h 2d 3c 3d",
    "2h 7h 2d 3c 3d",
    "2h 7h 7d 7c 7s",
    "th jh qh kh ah",
    "4h 4s ks 5d ts",
    "qc tc 7c 6c 4c",
    "ah ah 7c 6c 4c"
];

hands[]
| "\(.): \(analyzeHand)"
