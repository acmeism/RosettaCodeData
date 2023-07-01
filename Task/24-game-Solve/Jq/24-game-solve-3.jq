def OPERATORS: ["+", "-", "*", "/"];

# Input: an array of 4 digits
# o: an array of 3 operators
# Output: a stream
def EXPRESSIONS(o):
   intersperse( o ) | triples;

def solve(objective):
  length as $length
  | [ (OPERATORS | take($length-1)) as $poperators
    | permutations | EXPRESSIONS($poperators)
    | select( eval == objective)
  ] as $answers
  | if $answers|length > 3 then "That was too easy. I found \($answers|length) answers, e.g. \($answers[0] | pp)"
    elif $answers|length > 1 then $answers[] | pp
    else "You lose! There are no solutions."
    end
;

solve(24), "Please try again."
