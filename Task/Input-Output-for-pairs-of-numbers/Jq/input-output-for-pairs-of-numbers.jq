< input.txt jq -n '
  input as $n
  | if $n | (type != "number" or . < 0)
    then "Number of pairs must be non-negative." | error
    else range(0; $n)
    | [input,input] | add
    end'
