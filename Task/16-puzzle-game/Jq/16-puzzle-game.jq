include "MRG32k3a" {search: "."};  # see comment above

### Generic functions

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def inform(msg):
  . as $in
  | msg | stderr | $in;


### The 16-Puzzle Game

def easy: 1;

def hard: 4;

def drawGrid:
  def row($left; $array; $right):
    ([$left, ($array[] | lpad(2) ), $right] | join(" ║ ")) + "\n";
  inform(
    "     D1   D2   D3   D4\n"
  + "   ╔════╦════╦════╦════╗\n"
  +  row("R1"; .n[0:4]; "L1")
  + "   ╠════╬════╬════╬════╣\n"
  +  row("R2"; .n[4:8]; "L2")
  + "   ╠════╬════╬════╬════╣\n"
  +  row("R3"; .n[8:12];" L3")
  + "   ╠════╬════╬════╬════╣\n"
  +  row("R4"; .n[12:16];"L4")
  + "   ╚════╩════╩════╩════╝\n"
  + "     U1   U2   U3   U4\n"
  );

# If $check is a string, interpret it as a regex to be checked.
# Otherwise, allow any non-blank input
def prompt($prompt; $check):
  def p:
    inform($prompt)
    | try input catch halt
    | if ($check|type) == "string"
      then if (try test($check) catch false) then .
           else p
           end
      elif trim != "" then .
      else p
      end;
  p;

def initGrid:
  {n: [range ( 0; 16) | . + 1]};

# Input: {n}
# $ix should be an array of length 4
def rotate($ix):
  .n[$ix[3]] as $last
  | reduce range (3; 0; -1) as $i (.; .n[$ix[$i]] = .n[$ix[$i-1]])
  | .n[$ix[0]] = $last;

def hasWon:
  .n as $n
  | all( range(0;15); . as $i | $n[$i] == $i + 1);

# Input: {prng} as per MRG32k3a
# Output: {prng, prn} where .prn is randomly selected from range(0;$n)
def prn($n):
  .prng |= nextFloat
  | .prn = (.prng|.nextFloat * $n | trunc) ;

# Set difficulty level
# Input: {n}
def setDiff($level):
  (if $level == easy then 3 else 12 end) as $moves
  | .rc = []
  | .i = 0
  | .prng = (seed(now | tostring | sub("^.*[.]";"") | tonumber))
  | until(.i >= $moves;
      .rc = []
      | prn(2)   | .prn as $r
      | prn(4)   | .prn as $s
      | if ($r == 0)
        then reduce range($s*4; ($s+1)*4) as $j (.; .rc += [$j] )
        else  # rotate random column
             reduce range($s; $s+16; 4) as $j (.; .rc += [$j] )
        end
      | rotate(.rc)
      | if hasWon
        then # start again
         .i = -1
        end
      | .i +=  1
    )
  | inform("Target is \($moves) moves.\n");

def play:
  def trim: gsub(" ";"");
  def difficulty:
    prompt("Enter difficulty level (E for easy, H for hard): "; "^[eEhH]")
    | .[:1]
    | ascii_upcase;

  initGrid
  | .level = (if difficulty == "H" then hard else easy end)
  | setDiff(.level)
  | inform("When entering moves, you can also enter Q to quit or S to start again.\n")
  | .moves = 0
  | label $out
  | recurse(
      drawGrid
      | if hasWon
        then inform( "Congratulations, you have won the game in \(.moves) moves!\n")
        | break $out
        end
      | inform("Moves so far = \(.moves)\n")
      | (prompt("Enter move : "; "^ *([qsQS]|[drluDRLU] *[1234])")
         | ascii_upcase | trim) as $move
      | $move[:1] as $a
      | (if $a | test("[SQ]")
         then null
         else (($move[1:]|explode[0]) - 49)
         end ) as $c
      | if $a == "D"
        then rotate([0,4,8,12] | map(. + $c))
        | .moves += 1
        elif $a == "L"
        then rotate([3,2,1,0] | map(. + 4*$c))
        | .moves += 1
        elif $a == "U"
        then rotate([12,8,4,0] | map(. + $c))
        | .moves += 1
        elif $a == "R"
        then rotate([0,1,2,3] | map(. + 4*$c))
        | .moves += 1
        elif $move == "Q"
        then break $out
        elif $move == "S"
        then inform("Restarting...\n")
        | initGrid
        | setDiff(.level)
        | .moves = 0
        else inform("Invalid move, try again.\n")
        end )
  | empty ;

play
