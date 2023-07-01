include "rational"; # see [[Arithmetic/Rational#jq]]

### Generic Utilities

# counting from 0
def enumerate(s): foreach s as $x (-1; .+1; [., $x]);

# input string is converted from "base" to an integer, within limits
# of the underlying arithmetic operations, and without error-checking:
def to_i(base):
  explode
  | reverse
  | map(if . > 96  then . - 87 else . - 48 end)  # "a" ~ 97 => 10 ~ 87
  | reduce .[] as $c
      # state: [power, ans]
      ([1,0]; (.[0] * base) as $b | [$b, .[1] + (.[0] * $c)])
  | .[1];

### The Calkin-Wilf Sequence

# Emit an array of $n terms
def calkinWilf($n):
  reduce range(1;$n) as $i ( [r(1;1)];
    radd(1; rminus( rmult(2; (.[$i-1]|rfloor)); .[$i-1])) as $t
    | .[$i] = rdiv(r(1;1) ; $t)) ;

# input: a Rational
def toContinued:
  { a: .n,
    b: .d,
    res: [] }
  | until( .break;
      .res += [.a / .b | floor]
      | (.a % .b) as $t
      | .a = .b
      | .b = $t
      | .break = (.a == 1) )
  | if .res|length % 2 == 0
    then # ensure always odd
      .res[-1] += -1
    | .res += [1]
    else .
    end
  | .res;

# input: an array representing a continued fraction
def getTermNumber:
  reduce .[] as $n ( {b: "", d: "1"};
      .b = (.d * $n) + .b
    | .d = (if .d == "1" then "0" else "1" end))
  | .b | to_i(2) ;

# input: a Rational in the Calkin-Wilf sequence
def getTermNumber:
  reduce .[] as $n ( {b: "", d: "1"};
      .b = (.d * $n) + .b
    | .d = (if .d == "1" then "0" else "1" end))
  | .b | to_i(2) ;

def task(r):
  "The first 20 terms of the Calkin-Wilf sequence are:",
  (enumerate(calkinWilf(20)[]) | "\(1+.[0]): \(.[1]|rpp)" ),
  "",
  "\(r|rpp) is term # \(r|toContinued|getTermNumber) of the sequence.";

task( r(83116; 51639) )
