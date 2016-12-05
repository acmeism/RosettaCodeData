 "Pick 2:",
 (["iced", "jam", "plain"] | pick(2)),
 ([[range(0;10)] | pick(3)] | length) as $n
  | "There are \($n) ways to pick 3 objects with replacement from 10."
