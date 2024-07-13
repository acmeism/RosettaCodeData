include "MRG32k3a" {search: "."};  # see above

def task1:
  foreach range(0; 5) as $i (seed(1234567); nextInt ) | .nextInt;

def task2($n):
  seed(987654321)
  | reduce range(0; $n) as $i (.counts = [range(0;5)|0];
      nextFloat
      | .counts[ (.nextFloat * 5) | floor ] += 1 )
 | "\nThe counts for \($n) repetitions are:",
   (range(0;5) as $i | "  \($i) : \(.counts[$i] // 0)");

task1,
task2(100000)
