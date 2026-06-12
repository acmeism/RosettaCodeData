# The following can be omitted if using the C or Go implementations:
def range(a; b; c):
  if   a < b and c > 0 then a | while(. < b; .+c)
  elif a > b and c < 0 then a | while(. > b; . + c)
  else empty
  end;

# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def randFloat: 1000 | prn / 999;

def inner_product($x; $y):
   if ($x|length) !=  ($y|length) then "inner_product" | error else . end
   | reduce range(0; $x|length) as $i (0; . + $x[$i] * $y[$i]);

# the function being learned is f(x) = 2x + 1
def targetOutput(a; b):
  if (a * 2 + 1 < b) then 1 else -1 end;

def showTargetOutput:
  reduce range(10; -10; -1) as $y ("";
    reduce range(-9; 11) as $x (.;
      if targetOutput($x; $y) == 1
      then . + "#"
      else . + "O"
      end )
    | . + "\n" );

# output: an array of weights
def randomWeights($n):
  reduce range(0; $n) as $i ([]; .[$i] = randFloat * 2 - 1 )
# Or, for testing:
# [0.49215609849927, 0.80317011428771, 0.7062026506222]
;

# The perceptron outputs 1 if the inner product of the
# two arrays is positive, else -1
def feedForward($inputs; $weights):
   if inner_product($inputs; $weights) > 0 then 1 else -1 end;

def showOutput($ws):
   reduce range(10; -10; -1) as $y ("";
     reduce range(-9; 11) as $x (.;
        # bias is 1
        if feedForward([$x, $y, 1]; $ws) == 1
        then . + "#"
        else . + "O"
        end )
     | . + "\n" );

# input: {weights}
# output: updated weights
def train(runs):
  (.weights|length) as $nw
  | .inputs = [range(0; $nw)|0]
  | .inputs[-1] = 1  # bias is 1
  | reduce range(0; runs) as $i (.;
       reduce range(10; -10; -1) as $y (.;
         .inputs[1] = $y
         | reduce range(-9; 11) as $x (.;
            .inputs[0] = $x
            | (targetOutput($x; $y) - feedForward(.inputs; .weights)) as $error
            | reduce range(0; $nw) as $j (.;
	        # 0.01 is the learning constant
                .weights[$j] += $error * .inputs[$j] * 0.01 ) ) ) ) ;

def task:
  "Target output for the function f(x) = 2x + 1:",
  showTargetOutput,
  "Output from untrained perceptron:",
  ({weights: randomWeights(3)}
   | showOutput(.weights),
     (train(1)
      | "Output from perceptron after 1 training run:",
        showOutput(.weights),
        (train(99)
         | "Output from perceptron after 5 training runs:",
           showOutput(.weights) ) ) ) ;

task
