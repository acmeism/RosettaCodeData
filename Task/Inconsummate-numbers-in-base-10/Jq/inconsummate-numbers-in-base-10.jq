def digitSum:
  def add(s): reduce s as $_ (0; .+$_);
  add(tostring | explode[] | . - 48);

# Maximum ratio for 6 digit numbers is 100,000
def cons:
  reduce range(1; 1000000) as $i ([];
    ($i | digitSum) as $ds
    | ($i/$ds) as $ids
    | if $ids|floor == $ids then .[$ids] = true else . end);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task($n; $nth):
  cons as $cons
  | reduce range(1; $cons|length) as $i ([];
      if ($cons[$i]|not) then . + [$i] else . end)
  | "First \($n) inconsummate numbers in base 10:",
    (.[0:50] | _nwise(10) | map(lpad(3)) | join(" ")),
    "\nThe \($nth)th:",
    .[$nth - 1];

task(50; 1000)
