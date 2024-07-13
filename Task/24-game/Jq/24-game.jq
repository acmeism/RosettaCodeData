### The MRG32k3a combined recursive PRNG - see above
import "MRG32k3a" as MRG {search: "."};

### Generic utilities
def sum(stream): reduce stream as $x (0; .+$x);

# like while/2 but emit the final term rather than the first one
def whilst(cond; update):
  def _whilst:
    if cond then update | (., _whilst) else empty end;
  _whilst;

### Reverse Polish Notation
# An array of the allowed operators
def operators: "+-*/" | split("");

# If $a and $b are numbers and $c an operator, then "$a $b $c" is evaluated as an RPN expression.
# Output: {emit, result} with .emit == null if there is a valid result.
def applyOperator($a; $b; $c):
  if ([$a,$b] | map(type) | unique) == ["number"]
  then
    if   $c == "+" then   {result: ($a + $b)}
    elif $c == "-" then   {result: ($a - $b)}
    elif $c == "*" then   {result: ($a * $b)}
    elif ($c == "/") then {result: ($b / $a)}
    else {emit: "unrecognized operator: \($c)"}
    end
  else {emit: "invalid number"}
  end;

# Input: an array representing an RPN expression.
# Output: {emit, result} as per applyOperator/3
# Example: [1,2,3,"+","+"] | evaluate #=> 6
def evaluate:
  if length == 1
  then if .[0]|type == "number" then {result: .[0]}
       else {emit: "invalid RPN expression"}
       end
  elif length < 3 then {emit: "invalid RPN expression: \(. | join(" "))"}
  else . as $in
  | (first( range(0; length) as $i | select(any( operators[]; . == $in[$i]) ) | $i) // null) as $ix
  | if $ix == null then {emit: "invalid RPN expression"}
    else applyOperator(.[$ix-2]; .[$ix-1]; .[$ix]) as $result
    | if $result.result then .[:$ix-2] + [$result.result] + .[$ix+1:] | evaluate
      else $result
      end
    end
  end;

### The "24 Game"

# . is the putative RPN string to be checked.
# $four is the string of the four expected digits, in order.
# Output: {emit, result} with .emit set to "Correct!" if .result == 24
def check($four):
  if (gsub("[^1-9]";"") | explode | sort | implode) != $four
  then {emit: "You must use each of the four digits \($four | split("") | join(" ")) exactly once:"}
  else . as $in
        | {s: [], emit: null}
        | [$in | split("")[] | select(. != " ")
           | . as $in | explode[0] | if . >= 48 and . <= 57 then . - 48 else $in end]
        | evaluate
        | if .result
          then if .result|round == 24 then .emit = "Correct!"
               else .emit = "Value \(.result) is not 24."
               end
          else .emit += "\nTry again, or enter . to start again, or q to quit."
          end
   end ;

def run:
  # Populate .digits with four non-negative digits selected at random, with replacement:
  {digits: (9 | MRG::prn(4) | map(. + 1))}
  | (.digits | sort | join("")) as $four
  | "At the prompt, enter an RPN string (e.g. 64*1+1-), or . for a new set of four digits, or q to quit.",
    "Make 24 using these digits, once each, in any order: \(.digits):",
    ( whilst( .stop | not;
         .emit = null
         | . as $state
         | try input catch halt
         | if IN( "q", "quit") then halt
           elif . == "." then $state | .stop = true
           else check($four)
           | if .result then .stop = true end
           end )
     | select(.emit).emit ),
       # rerun
       run;

run
