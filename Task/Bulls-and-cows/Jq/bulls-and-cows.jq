# A PRNG for generating a pseudo-random integer in range(0; .).
# $array must be a sufficiently large array of pseudo-random integers in range(0;10).
# $start specifies the position in $array to begin searching.
# Output: {prn, start) where .prn is a PRN in range(0; .) and .start is the corresponding position in $array.
def prn($array; $start):
  def a2n: map(tostring) | join("") | tonumber;
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | {$start}
  | until( $array[.start: .start + $w] | a2n < $n; .start+=1 )
  | {start, prn: ($raw[.start: .start + $w] | a2n)}
  end;

# Generate a 4-digit PRN from 1234 to 9876 inclusive, with no zeros or repeated digits.
# Global variable: $raw (see documentation for $array above)
def num:
  def _num($start):
    (8643|prn($raw; $start)) as $prn
    | (1234 + $prn.prn)
    | . as $n
    | tostring
    | if (test("0")|not) and ((explode|unique|length) == 4)
      then $n
      else _num($prn.start+4)
    end;
  _num(0);

def MAX_GUESSES: 20;  # say

def instructions:
 "All guesses should have exactly 4 distinct digits excluding zero.",
 "Keep guessing until you guess the chosen number (maximum \(MAX_GUESSES) valid guesses).\n";

def play:
  num as $num
  | ($num|tostring|explode) as $numArray
  | { guesses: 0 }
  | instructions, "Enter your guess:",
    (label $out
     | foreach range(0; infinite) as $i (.;
         if .bulls == 4 or .guesses == MAX_GUESSES then break $out
         else .guess = input
         | if .guess == $num then .emit = "You have won with \(.guesses+1) valid guesses!"
           else .n = (.guess | try tonumber catch null)
           | if .n == null               then .emit = "Not a valid number"
             elif .guess|test("[+-.]")   then .emit = "The guess should not contain a sign or decimal point."
             elif .guess|test("0")       then .emit = "The guess cannot contain zero."
             elif .guess|length != 4     then .emit = "The guess must have exactly 4 digits."
             else .guessArray = (.guess | explode )
             | if .guessArray | unique | length < 4 then .emit = "All digits must be distinct."
               else . + {bulls: 0, cows: 0 }
               | reduce range(0; .guessArray|length) as $i ( .;
                   if $numArray[$i] == .guessArray[$i]      then .bulls += 1
                   elif (.guessArray[$i] | IN($numArray[])) then .cows  += 1
                   else .
                   end)
               | .emit = "Your score for this guess:  Bulls = \(.bulls)  Cows = \(.cows)"
               | .guesses += 1
               end
             end
           end
         end;

         select(.emit).emit,
         if .bulls == 4 then "Congratulations!"
         elif .guesses == MAX_GUESSES
         then "\nYou have now had \(.guesses) valid guesses, the maximum allowed. Bye!"
         else "Enter your next guess:"
         end ) );

play
