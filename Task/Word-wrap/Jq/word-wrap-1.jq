# Simple greedy algorithm.
# Note: very long words are not truncated.
# input: a string
# output: an array of strings
def wrap_text(width):
  reduce splits("\\s+") as $word
    ([""];
     .[length-1] as $current
     | ($word|length) as $wl
     | (if $current == "" then 0 else 1 end) as $pad
     | if $wl + $pad + ($current|length) <= width
       then .[-1] += ($pad * " ") + $word
       else . + [ $word]
       end );
