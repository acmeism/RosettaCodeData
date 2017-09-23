# Adapted from the go version.
# Tested with jq 1.4
#
# say/0 as defined here supports positive and negative integers within
# the range of accuracy of jq, or up to the quintillions, whichever is
# less.  As of jq version 1.4, jq's integer accuracy is about 10^16.

def say:

  # subfunction zillions recursively handles the thousands,
  # millions, billions, etc.
  #   input: the number
  #   i: which "illion" to use
  #   sx: the string so far
  #   output: the updated string
  def zillions(i; sx):
    ["thousand", "million", "billion",
      "trillion", "quadrillion", "quintillion"] as $illions
    | if . == 0 then sx
       else (. / 1000 | floor)
            | (. % 1000) as $p
            | zillions(i + 1;
                       if $p > 0 then
                          (($p | say) + " " + $illions[i]) as $ix
                          | if sx != "" then $ix + ", " + sx
                            else $ix
                            end
                       else sx
                       end)
       end
  ;

  [ "", "one", "two", "three", "four", "five", "six", "seven",
    "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
    "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"] as $small
  | ["ones", "ten", "twenty", "thirty", "forty",
     "fifty", "sixty", "seventy", "eighty", "ninety"] as $tens

  | if . == 0 then "zero"
    elif . < 0 then "minus " + (-(.) | say)
    elif . < 20 then $small[.]
    elif . < 100 then
        $tens[./10|floor] as $t
        | (. % 10)
        | if . > 0 then ($t + " " + $small[.]) else $t end
    elif . < 1000 then
        ($small[./100|floor] + " hundred") as $h
        | (. % 100)
        | if . > 0 then $h + " and " + (say) else $h end
    else
        # Handle values larger than 1000 by considering
        # the rightmost three digits separately from the rest:
        ((. % 1000)
         | if . == 0 then ""
           elif . < 100 then "and " + say
           else say
           end ) as $sx
        | zillions(0; $sx)
    end ;

say
