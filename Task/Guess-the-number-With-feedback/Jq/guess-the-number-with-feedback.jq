# $min and $max can be specified on the command line but for illustrative purposes:
def minmax: [0, 20];

# low-entropy PRNG in range($a;$b) i.e. $a <= prng < $b
# (no checking)
def prng($a;$b): $a + ((now * 1000000 | trunc) % ($b - $a) );

def play:
  # extract a number if possible
  def str2num:
    try tonumber catch null;

  minmax as [$min, $max]
  | prng($min; $max) as $number
  | "The computer has chosen a whole number between \($min) and \($max) inclusive.",
    "Please guess the number or type q to quit:",
    (label $out
     | foreach inputs as $guess (null;
       if $guess == "q" then null, break $out
       else ($guess|str2num) as $g
       | if   $g == null or $g < 0   then "Please enter a non-negative integer or q to quit"
         elif $g < $min or $g > $max then "That is out of range. Try again"
         elif $g > $number           then "Too high"
         elif $g < $number           then "Too low"
         else true, break $out
	 end
       end)
     | if type == "string" then .
       elif . == true then "Spot on!", "Let's start again.\n", play
       else empty
       end );

play
