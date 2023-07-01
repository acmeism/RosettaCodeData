def steps:
  [1, "a", "A"],
  [2, "a", "B"],
  [4, "a", "C"],
  [5, "a", "D"],
  [1, "b", "E"],
  [2, "r", "F"];

def task(steps):
  . as $reference
  | reduce steps as [$occurrence, $old, $new] (.;
      replace_nth($occurrence - 1; $old; $new; $reference ));

"abracadabra" | task(steps)
