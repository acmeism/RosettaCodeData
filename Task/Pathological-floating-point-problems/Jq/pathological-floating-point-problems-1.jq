# A (naive) limitless generator
def v:
  [2, -4]
  | recurse( [.[1], 111 - (1130 / .[1]) +   3000  /  (.[0] * .[1])] )
  | .[0];

[limit(100; v)]
| (3, 4, 5, 6, 7, 8, 20, 30, 50, 100) as $i
| [$i, .[$i - 1]]
