def isCurzon($n; $k):
  ($k | power($n) + 1) % ($k * $n + 1) == 0;

# Emit a stream of Curzon numbers base $k
def curzons($k):
  range(0; infinite) | select(isCurzon(.; $k));

# Print the first 50 and the $n-th Curzon numbers
# for k in range(klow; khigh+1; 2)
def printcurzons(klow; khigh; $n):
  range(klow; khigh+1; 2) as $k
  | [limit($n; curzons($k))] as $curzons
  | "Curzon numbers with k = \($k):",
    ($curzons[:50] | printRows(25) ),
    "    \($n)-th Curzon with k = \($k): \($curzons[$n - 1])",
    "";

printcurzons(2; 10; 1000)
