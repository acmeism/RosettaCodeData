def count_combinations_with_sum($sum):
  count( zero_or_one | select(add == $sum));

def count_permutations_with_sum($sum):
  count( zero_or_one | select(add == $sum) | map(select(.!=0)) | permutations);

# Each task takes the form of [ARRAY, SUM]
def task:
  . as [$array, $sum]
  | $array
  | count_combinations_with_sum($sum) as $n
  | count_permutations_with_sum($sum) as $p
  | "With coins \($array) and target sum \($sum):",
    "   #combinations is \($n)",
    "   #permutations is \($p)\n";

[[1,2,3,4,5],6],
[[1, 1, 2, 3, 3, 4, 5], 6],
[[1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100], 40]
| task
