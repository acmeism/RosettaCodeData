### Generic functions
# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# Input: a nonempty array of non-increasing non-negative integers
# Output: the overall percentage decrease
def percentageDecrease:
  if .[0] == 0
  then 0
  else 100 - ((.[-1] / .[0]) * 100)
  end;

# Input: an array
# Emit a stream of maximal non-increasing subsequences, include singletons
def maximal_nonincreasing_subsequences:
  foreach (.[], null) as $x ({subsequence: []};
     .emit = null
     | if $x == null
       then if (.subsequence|length) > 0 then .emit = .subsequence
            else empty
            end
       elif (.subsequence | length) == 0 or  $x <= .subsequence[-1]
       then .subsequence += [$x]
       else if (.subsequence | length) > 0
            then .emit = .subsequence
            end
       | .subsequence = [$x]
       end )
   | select(.emit).emit;

# Classify the input numbers as per the implementation
def bucketize:
  if . <= 0 then empty
  elif . < 4 then "  4"
  elif . < 8 then "  8"
  elif . < 12 then " 12"
  elif . < 16 then " 16"
  elif . < 25 then " 25"
  else "100"
  end;

# Input: an array of non-negative numbers.
# Output: a JSON object that gives the classification of the maximal
# non-decreasing subsequences as per the task description
def classify:
  def zero: {"  4":0, "  8":0, " 12":0, " 16":0, " 25":0, "100": 0};

  bow(maximal_nonincreasing_subsequences
      | percentageDecrease
      | bucketize)
  | to_entries
  | zero + from_entries;

# The example:
classify
