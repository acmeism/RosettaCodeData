# add_pairs is a helper function for optpascal/0
# Input: an OptPascal array
# Output: the next OptPascal array (obtained by adding adjacent items,
# but if the last two items are unequal, then their sum is repeated)
def add_pairs:
  if length <= 1 then .
  elif length == 2 then (.[0] + .[1]) as $S
  | if (.[0] == .[1]) then [$S]
    else [$S,$S]
    end
  else [.[0] + .[1]] + (.[1:]|add_pairs)
  end;

# Input: an OptPascal row
# Output: the next OptPascalRow
def next_optpascal: [1] + add_pairs;

# generate a stream of OptPascal arrays, beginning with []
def optpascals: [] | recurse(next_optpascal);

# generate a stream of Pascal arrays
def pascals:
  # pascalize takes as input an OptPascal array and produces
  # the corresponding Pascal array;
  # if the input ends in a pair, then peel it off before reversing it.
  def pascalize:
  . + ((if .[-2] == .[-1] then .[0:-2] else .[0:-1] end) | reverse);

  optpascals | pascalize;

# Input: integer n
# Output: the n-th Pascal row
def pascal: nth(.; pascals);

def optpascal: nth(.; optpascals);
