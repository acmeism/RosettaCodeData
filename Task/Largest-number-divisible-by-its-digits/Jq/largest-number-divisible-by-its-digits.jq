def has_unique_digits:
  tostring
  | explode
  | label $out
  | (foreach map([.] | implode)[] as $d ({};
      .[$d] += 1;
      select(.[$d] > 1) | (0, break $out)))
    // true
    | . == true;

# exclude numbers with a 0
def is_divisible_by_all_its_digits:
  . as $n
  | tostring
  | explode
  | map([.] | implode | tonumber) as $digits
  | all($digits[]; . != 0) and
    all($digits[]; $n % . == 0);

def task:
  def solve($startn; $stopn; $comdiv):
    ($startn - ($startn % $comdiv))
    | while (. >= $stopn; . - $comdiv)
    | select(has_unique_digits and is_divisible_by_all_its_digits);
  first(solve(9876543; 1000000; 12));

task
