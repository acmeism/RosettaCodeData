include "MRG32k3a" {search: "."};  # see comment above

### Generic functions

def inform(msg):
  . as $in
  | msg + "\n" | stderr
  | $in;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Create an m x n matrix with initial values specified by .
def matrix($m; $n):
  if $m == 0 then []
  else . as $init
  | if $m == 1 then [range(0;$n) | $init]
    elif $m > 0 then
    matrix(1; $n) as $row
    | [range(0; $m) | $row ]
    else error("matrix\($m);\($n)) invalid")
    end
  end;


### Tic-Tac-Toe

# The board is represented by a matrix in which:
#   0 : blank; -1: computer; 1: user
def init:
  {b: (0 | matrix(3;3)),
   bestI: 0,
   bestJ: 0,
   prng: seed(now | tostring | sub("^.*[.]";"") | tonumber)};

# Output: 0 if undecided, null if game over, otherwise the player id
def checkWinner:
  first(range(0; 3) as $i
     | if   .b[$i][0] != 0 and .b[$i][1] == .b[$i][0] and .b[$i][2] == .b[$i][0] then .b[$i][0]
       elif .b[0][$i] != 0 and .b[1][$i] == .b[0][$i] and .b[2][$i] == .b[0][$i] then .b[0][$i]
       else empty
       end)
  //   if   (.b[1][1] == 0) then 0
       elif (.b[1][1] == .b[0][0] and .b[2][2] == .b[0][0]) then .b[0][0]
       elif (.b[1][1] == .b[2][0] and .b[0][2] == .b[1][1]) then .b[1][1]
       elif all(.b[][]; . != 0) then null
       else 0
       end ;

def showBoard:
  ["X", " ", "O"] as $t
  | .b as $b
  | range(0;3) as $i
  | reduce range(0;3) as $j ("";
          . + "\($t[$b[$i][$j] + 1]) " ),  # b == -1 => "X";  b == 1 => "O"
  "-----";

# Examine possible moves of the player identified by $value, avoiding embarrassment
# Set .result, .bestI, .bestJ, etc
def testMove($value; $depth):
  checkWinner as $score
  | if $score == null then .result = 0
    elif $score != 0
    then .result = (if $score == $value then 1 else -1 end)
    else .best = -1
    | .changed = 0
    | reduce range(0;3) as $i (.;
        reduce range(0;3) as $j (.;
          if .b[$i][$j] == 0
          then .b[$i][$j] = $value
          | .changed = $value
          | testMove(-$value; $depth + 1) as $test
          | (-$test.result) as $score
          | .b[$i][$j] = 0
          | if $score > .best
            then if $depth == 0
                 then .bestI = $i
                    | .bestJ = $j
                 end
                 | .best = $score
            end
          end ) )
    | .result = if .changed != 0 then .best else 0 end
    end;

# Issue prompts on stderr;
# always allow q for quit
def read($prompt; $regex):
  def r:
    ($prompt | stderr | empty),
    (try ((input
          | if . == "q" then halt
            else select(test($regex))
            end) // r)
     catch if . == "break" then halt else r end );
  r;

# Input: irrelevant
# $user should be boolean; specify `true` if the user plays first
def game($user):
  "Board positions are numbered so:\n1 2 3\n4 5 6\n7 8 9",
  "You have O, I have X.\n",
  (init + {$user}
   | label $out
   | foreach range(0;9) as $k (.;
        if .user
        then .move = null
        | until(.move;
            (read("Your move: "; "^ *[1-9]") | tonumber - 1) as $move
            | ($move/3|floor) as $i
            | ($move % 3) as $j
            | if   .b[$i][$j] == 0
              then .b[$i][$j] = 1
              | .move = $move
              end )
        end
        | if (.user|not)
          then # in the interests of entertainment, randomize if computer opens
               if $k == 0
               then .prng |= nextFloat
               | .bestI = (.prng.nextFloat * 100 | trunc) % 3
               | .prng |= nextFloat
               | .bestJ = (.prng.nextFloat * 100 | trunc) % 3
               else testMove(-1; 0)
               end
          | .b[.bestI][.bestJ] = -1
          | inform("My move: \(.bestI * 3 + .bestJ + 1)")
          end
        | .user |= not
        ;
        # Output:
        showBoard,
        (checkWinner
         | if . == 0 then empty
           else (if  . ==  1 then "You win"
                 elif . == -1 then "I win"
                 else              "A draw.\n\n"
                 end),
                break $out
           end ) )) ;

# Alternate players
def controller:
  def c($user):
    game($user),
    (read("Play again? [yn]: "; "^[yYnN]") as $in
     | if $in|.[0:1]|ascii_downcase == "n" then halt
       else c($user|not)
       end);
  c(true);

controller
