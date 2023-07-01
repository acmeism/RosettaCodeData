# "rule" can be given as a decimal or string of 0s and 1s:
def automaton(rule; steps):

  # Compute the rule as a string of length 8
  def tos:
    if type == "number" then "0000000" + binary_digits else . end
    | .[-8:];

  # input: the current state of the automaton
  # output: its next state
  def update(rule):
    . as $in
    | reduce range(0; length) as $n ("";
      . + ($in|triple($n)|next(rule)));

  (rule | tos) as $rule
  | limit(steps; while(true; update($rule) )) ;

# Example

"0000001000000"             # initial state
| automaton($rule; $steps)  # $rule and $steps are taken from the command line
| gsub("0"; ".")            # pretty print
| gsub("1"; "#")
