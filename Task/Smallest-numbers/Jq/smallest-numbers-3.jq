def task($n):
  [range(0; $n) | smallest_k | lpad(3) ]
  | nwise(10)
  | join(" ");

task(51)
