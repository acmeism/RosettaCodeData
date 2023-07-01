# input and output: {limits, count} where
#   .limits holds an array defining the limits, and
#   .count[$i] holds the count of bin $i, where bin[0] is the left-most bin
def bin($x):
  (.limits | bsearch($x)) as $ix
  | (if $ix > -1 then $ix + 1 else -1 - $ix end) as $i
  | .count[$i] += 1;

# pretty-print for the structure defined at bin/1
def pp:
   (.limits|length) as $length
   | (range(0;$length) as $i
      | "< \(.limits[$i]) => \(.count[$i] // 0)" ),
     ">= \(.limits[$length-1] ) => \(.count[$length] // 0)"  ;

# Main program
reduce inputs as $x ({$limits, count: []}; bin($x))
| pp
