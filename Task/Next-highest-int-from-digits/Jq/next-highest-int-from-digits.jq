# Generate a stream of all the permutations of the input array
def permutations:
  # Given an array as input, generate a stream by inserting $x at different positions
  def insert($x):
     range (0; length + 1) as $pos
     | .[0:$pos] + [$x] + .[$pos:];

  if length <= 1 then .
  else
    .[0] as $first
    | .[1:] | permutations | insert($first)
  end;

def next_highest:
  (tostring | explode) as $digits
  | ([$digits | permutations] | unique) as $permutations
  | ($permutations | bsearch($digits)) as $i
  | if $i == (($permutations|length) - 1) then 0
    else $permutations[$i+1] | implode
    end;

def task:
  0,
  9,
  12,
  21,
  12453,
  738440,
  45072010,
  95322020;

task | "\(.) => \(next_highest)"
